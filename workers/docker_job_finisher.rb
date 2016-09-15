require_relative '../config/initializers/sidekiq.rb'

# Worker class to schedule docker job
class DockerJobFinisher
  include Sidekiq::Worker
  def perform(job_id)
    job = Job.find(job_id)
    job.update_attributes(status: 'RUNNING')

    InstanceManager.new(
      docker_image: job.docker_image,
      env_vars: job.env_vars,
      job_id: job.id
    ).remove
  end
end
