require 'sinatra/activerecord'
require 'time'
require_relative '../modules/jobs.rb'

# Manage Jobs
class JobManage
  attr_accessor :docker_image, :env_vars, :scheduled_for

  def initialize(docker_image, env_vars)
    @docker_image = docker_image
    @env_vars = env_vars
  end

  def run(job_id)
    puts "Deu certo #{Time.now}.
    docker_image: #{@docker_image},
    env_vars: #{@env_vars}"

    job = Jobs.find_by(id: job_id)
    job.update_attributes(status: 'RUNNING')

    sleep 60

    job.update_attributes(status: 'DONE')
  end

  def create(scheduled_for)
    Jobs.create(
      docker_image: @docker_image,
      env_vars: @env_vars,
      scheduled_for: scheduled_for,
      status: 'SCHEDULED'
    )
  end
end
