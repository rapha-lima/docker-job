# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'rack/conneg'
require 'sinatra/activerecord'
require_relative 'modules/jobs.rb'

get '/list' do
  jobs = Jobs.all
  return jobs.to_json
end

get '/status/:id' do
  id = params[:id]
  job = Jobs.where(id: id)

  if id.nil? || id.empty?
    halt 400, { message: 'id field cannot be empty' }.to_json
  elsif job.nil? || job.empty?
    halt 400, { message: "Job id #{id} was not found" }.to_json
  else
    return job.pluck(:status).to_json
  end
end

post '/schedule' do
  name = params[:name]
  docker_image = params[:docker_image]
  scheduled_for = params[:scheduled_for]
  env_vars = params[:env_vars]

  if docker_image.nil? || docker_image.empty?
    halt 400, { message: 'docker_image field cannot be empty' }.to_json
  elsif scheduled_for.nil? || scheduled_for.empty?
    halt 400, { message: 'scheduled_for field cannot be empty' }.to_json
  else
    job = Jobs.create(
      name: name,
      docker_image: docker_image,
      env_vars: env_vars,
      scheduled_for: scheduled_for,
      status: 'SCHEDULED'
    )

    return "Job #{job.name} scheduled"
  end
end

put '/callback/:id' do
  id = params[:id]
  reschedule = params[:reschedule]
  job = Jobs.find_by(id: id)

  if reschedule == 'true'
    scheduled_for = (job.scheduled_for + 10.minutes).to_datetime
    job.update_attributes(scheduled_for: scheduled_for, status: 'RESCHEDULED')
  elsif reschedule == 'false'
    job.update_attributes(status: 'DONE')
  end
end
