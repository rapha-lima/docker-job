# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'time'
require 'dotenv'
require_relative 'models/job.rb'
require_relative 'runners/instance_manager.rb'
require_relative 'modules/tools.rb'

Dotenv.load

# Modular Application
class App < Sinatra::Application
  include Tools

  get '/list' do
    status 200
    Job.all.to_json
  end

  get '/status/:id' do
    parse_body
    job = Job.where(id: @response_body.id)

    validate_status_params(job)

    job.pluck(:status)
  end

  post '/schedule' do
    parse_body

    validate_schedule_params
    validate_time

    job = Job.create(
      docker_image: @response_body[:docker_image],
      scheduled_for: @response_body[:scheduled_for],
      env_vars: @response_body[:env_vars],
      status: 'SCHEDULE'
    )

    # DockerJob.perform_in(@response_body[:scheduled_for], job.id)

    job
  end

  put '/callback/:id' do
    job = Jobs.find(params[:id])

    if params[:reschedule]
      job.update_attributes(scheduled_for: 10.minutes.from_now, status: 'RESCHEDULED')
    else
      job.update_attributes(status: 'DONE')
    end
  end

  private

  def parse_body
    request.body.rewind
    response_body = JSON.parse params.body.read
    response_body['scheduled_for'] = Time.parse(response_body['scheduled_for']) if response_body['scheduled_for']
    @response_body = response_body.symbolize_keys
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
