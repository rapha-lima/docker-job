require 'sinatra/activerecord'
require 'time'
require_relative '../modules/jobs.rb'

# Manage Jobs
class JobManage
  attr_accessor :job_id, :docker_image, :env_vars, :scheduled_for

  def initialize(job_id, docker_image, env_vars, scheduled_for: nil)
    @job_id = job_id
    @docker_image = docker_image
    @env_vars = env_vars
    @scheduled_for = scheduled_for
  end

  def run
    puts "Deu certo #{Time.now}.
    docker_image: #{@docker_image},
    env_vars: #{@env_vars}"

    job = Jobs.find_by(id: @job_id)
    job.update_attributes(status: 'RUNNING')

    sleep 60

    job.update_attributes(status: 'DONE')
  end
end
