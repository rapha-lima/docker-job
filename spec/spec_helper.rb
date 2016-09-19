require 'rspec'
require 'rack/test'
require 'support/factory_girl'
require 'support/rspec_sidekiq'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  def app
    App
  end
end
