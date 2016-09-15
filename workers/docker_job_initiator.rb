require_relative '../config/initializers/sidekiq.rb'
require_relative '../runners/instance_manager.rb'

# Worker class to schedule docker job
class DockerJobInitiator
  include Sidekiq::Worker
  def perform(job_id)
    job = Job.find(job_id)
    job.update_attributes(status: 'RUNNING')

    InstanceManager.new(job.id).create
  end
end
