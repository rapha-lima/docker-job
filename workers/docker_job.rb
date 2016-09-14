require_relative '../config/initializers/sidekiq.rb'
require_relative '../lib/job_manage.rb'

# Worker class to schedule docker job
class DockerJob
  include Sidekiq::Worker
  def perform(docker_image, env_vars, job_id)
    Jobs.findjhbdfurhgjntrohjni.udokdihkjrnnegoln
    job = JobManage.new(docker_image, env_vars)
    job.run(job_id)
  end
end
