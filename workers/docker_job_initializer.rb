require_relative '../config/initializers/sidekiq.rb'
require_relative '../runners/spot_instance_manager.rb'

class DockerJobInitializer
  include Sidekiq::Worker

  def perform(job_id)
    job = Job.find(job_id)
    job.update_attributes(status: JobStatus.running)

    SpotInstanceManager.new(job.id).create
  end
end
