# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'time'
require 'dotenv'
require 'json'
require_relative 'models/job.rb'
require_relative 'models/configuration.rb'
require_relative 'models/job_status.rb'
require_relative 'modules/tools.rb'
require_relative 'workers/docker_job_initializer.rb'
require_relative 'workers/docker_job_finisher.rb'

Dotenv.load

class App < Sinatra::Application
  include Tools

  get '/list' do
    status 200
    Job.all.map do |job|
      {
        id: job.id,
        docker_image: job.docker_image,
        env_vars: job.env_vars,
        schedule_for: job.scheduled_for.in_time_zone('America/Sao_Paulo'),
        spot_instance_request_id: job.spot_instance_request_id,
        status: job.status
      }
    end.to_json
  end

  get '/status/:id' do
    job = Job.where(id: params[:id])

    validate_status_params(job)

    job.pluck(:status)
  end

  post '/schedule' do
    load_body

    validate_schedule_params
    parse_time
    validate_time

    job = Job.create(
      docker_image: @response_body[:docker_image],
      scheduled_for: @response_body[:scheduled_for],
      env_vars: @response_body[:env_vars],
      status: JobStatus.schedule
    )

    DockerJobInitializer.perform_in(@response_body[:scheduled_for], job.id)

    job.to_json
  end

  put '/callback/:id' do
    load_body

    job = Job.find(params[:id])

    # schedule job again if spot instance receive spot termination-time
    if @response_body[:schedule]
      schedule_for = 5.minutes.from_now
      job.update_attributes(scheduled_for: schedule_for, status: JobStatus.schedule)

      DockerJobInitializer.perform_in(5.minutes.from_now, job.id)
    else
      DockerJobFinisher.perform_async(job.id)
    end

    job.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
