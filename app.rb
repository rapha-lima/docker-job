# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'rack/conneg'
require 'sinatra/activerecord'
require_relative 'modules/jobs.rb'

# Register Extension
class DockerJob < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

get '/list' do
  jobs = Jobs.all
  return jobs.to_json
end

get '/status/:id' do
  id = params[:id]
  job = Jobs.where(id: id)
  return job.pluck(:status).to_json
end

post '/schedule' do
  name = params[:name]

  if name.nil? || name.empty?
    halt 400, { message: 'name field cannot be empty' }.to_json
  else
    job = Jobs.create(name: name, status: 'DONE')

    return "Job #{job.name} scheduled"
  end
end

put '/callback/:id' do
  id = params[:id]
  job = Jobs.find_by(id: id)
  job.update_attributes(status: 'DONE')
end
