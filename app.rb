# Encoding: utf-8
require 'rubygems'
require 'bundler'

Bundler.require

require 'sinatra'
require 'roar/json/hal'
require 'rack/conneg'
require 'sinatra/activerecord'
require 'yaml'

# Register Extension
class DockerJob < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

# Validates jobs table
class Jobs < ActiveRecord::Base
  validates_presence_of :scheduled_for
  validates_presence_of :status
end

# JobsRepresenter
module JobsRepresenter
  include Roar::JSON::HAL

  property :name
  property :status

  link :self do
    "/jobs/#{id}"
  end
end

get '/jobs/?' do
  products = Jobs.all
  JobsRepresenter.for_collection.prepare(products).to_json
end
