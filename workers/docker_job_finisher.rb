require_relative '../config/initializers/sidekiq.rb'
require_relative '../runners/spot_instance_manager.rb'

class DockerJobFinisher
  include Sidekiq::Worker

  def perform(job_id)
    SpotInstanceManager.new(job_id).remove
  end
end
