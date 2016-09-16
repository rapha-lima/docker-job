require_relative '../config/initializers/sidekiq.rb'
require_relative '../runners/instance_manager.rb'

class DockerJobInitiator
  include Sidekiq::Worker
  def perform(job_id)
    job = Job.find(job_id)
    job.update_attributes(status: JobStatus.running)

    InstanceManager.new(job.id).create
  end
end
