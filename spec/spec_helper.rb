require 'rspec'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  def app
    App
  end
end

require File.expand_path '../../app.rb', __FILE__

# Define module RSpecMixin
module RSpecMixin
  include Rack::Test::Methods
  def app
    App
  end
end
