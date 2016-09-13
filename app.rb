# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'time'
require 'dotenv'
require_relative 'modules/jobs.rb'
require_relative 'workers/docker_job.rb'
require_relative 'lib/job_manage.rb'
require_relative 'runners/instance_create.rb'

Dotenv.load

# Modular Application
class App < Sinatra::Application
  # Create endpoint /aws to test class InstanceCreate.
  # It will be removed later
  get '/aws' do
    aws = InstanceCreate.new('redis', 'SLEEP_TIME=20 VAR1="teste"', 1)
    aws.run
  end

  get '/list' do
    jobs = Jobs.all
    status 200
    return jobs.to_json
  end

  get '/status/:id' do
    id = params[:id]
    job = Jobs.where(id: id)

    if job.nil? || job.empty?
      halt 400, { message: "Job id #{id} was not found" }.to_json
    else
      return job.pluck(:status).to_json
    end
  end

  post '/schedule' do
    docker_image = params[:docker_image]
    scheduled_for = params[:scheduled_for]
    env_vars = params[:env_vars]

    if docker_image.nil? || docker_image.empty?
      halt 400, { message: 'docker_image field cannot be empty' }.to_json
    elsif scheduled_for.nil? || scheduled_for.empty?
      halt 400, { message: 'scheduled_for field cannot be empty' }.to_json
    else
      scheduled_for = Time.parse(scheduled_for)
      validate_time(scheduled_for)

      job_created = JobManage.new(docker_image, env_vars).create(scheduled_for)

      job_id = job_created.id
      DockerJob.perform_in(scheduled_for, docker_image, env_vars, job_id)

      job = Jobs.where(id: job_id).select(:id)
      return job.to_json
    end
  end

  put '/callback/:id' do
    id = params[:id]
    reschedule = params[:reschedule]
    job = Jobs.find_by(id: id)

    if reschedule == 'true'
      scheduled_for = (Time.now + 10.minutes).to_datetime
      job.update_attributes(scheduled_for: scheduled_for, status: 'RESCHEDULED')
    elsif reschedule == 'false'
      job.update_attributes(status: 'DONE')
    end
  end

  private

  def validate_time(time)
    if time < Time.now
      message = "scheduled_for field must be greater than #{Time.now}"
      halt 400, { message: message }.to_json
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
