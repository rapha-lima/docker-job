# Encoding: utf-8
require 'rubygems'
require 'bundler'

# Bundler.require

require 'sinatra'
require 'roar/json/hal'
require 'rack/conneg'
# require 'sinatra/activerecord'
require 'active_record'
require 'yaml'

env = ENV['RACK_ENV'] || 'development'

database_config = YAML.load(File.open('config/database.yml'))[env]

database_config.symbolize_keys.each do |key, value|
  set key, value
end

ActiveRecord::Base.establish_connection(
  adapter: settings.db_adapter,
  host: settings.db_host,
  database: settings.db_name,
  username: settings.db_username,
  password: settings.db_password
)
