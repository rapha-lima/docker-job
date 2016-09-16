require_relative '../config/initializers/sidekiq.rb'
require_relative '../runners/instance_manager.rb'

class DockerJobFinisher
  include Sidekiq::Worker
  def perform(job_id)
    job = Job.find(job_id)
    job.update_attributes(status: JobStatus.done)

    InstanceManager.new(job.id).remove
  end
end
