# Worker class to schedule docker job
class DockerJob
  include Sidekiq::Worker
  def perform(docker_image, env_vars: nil)
    "Deu certo #{Time.now}.
    docker_image: #{docker_image},
    env_vars: #{env_vars}"
  end
end
