source 'https://rubygems.org'

# Sinatra
gem 'sinatra'

# Sinatra ActiveRecord Extension
gem 'sinatra-activerecord'
gem 'activerecord'
gem 'pg'
gem 'rake'

# Sidekiq
gem 'sidekiq'

# AWS SDK
gem 'aws-sdk', '~> 2'

# Dotenv
gem 'dotenv'

# Tools
gem 'settingslogic'

# RSpec
group :test do
  gem 'rspec'
  gem 'rack-test'
  %w(rspec-core rspec-expectations rspec-mocks rspec-support).each do |lib|
    gem lib
  end
  gem 'rspec-sidekiq'
  gem 'factory_girl'
  gem 'faker'
  gem 'pry-byebug'
end
