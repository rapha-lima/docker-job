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
require_relative 'modules/tools.rb'
require_relative 'workers/docker_job_initiator.rb'

Dotenv.load

# ./app.rb
class App < Sinatra::Application
  include Tools

  get '/list' do
    status 200
    Job.all.to_json
  end

  get '/status/:id' do
    job = Job.where(id: params[:id])

    validate_status_params(job)

    job.pluck(:status)
  end

  post '/schedule' do
    load_body

    validate_schedule_params
    convert_time
    validate_time

    job = Job.create(
      docker_image: @response_body[:docker_image],
      scheduled_for: @response_body[:scheduled_for],
      env_vars: @response_body[:env_vars],
      status: 'SCHEDULED'
    )

    DockerJobInitiator.perform_in(@response_body[:scheduled_for], job.id)

    job.to_json
  end

  put '/callback/:id' do
    load_body

    job = Jobs.find(params[:id])

    if params[:reschedule]
      job.update_attributes(scheduled_for: 5.minutes.from_now, status: 'SCHEDULED')
    else
      job.update_attributes(status: 'DONE')
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
