require 'aws-sdk'
require 'base64'

# ./runners/instance_manager.rb
class InstanceManager
  USER_DATA_FILE = File.read('config/templates/bootstrap.txt').freeze
  SPOT_INSTANCE_CONFIG = YAML.load_file('config/spot_instance_configuration.yml').freeze

  attr_accessor :job_id

  def initialize(job_id)
    @job = Job.find(job_id)
    @config = SPOT_INSTANCE_CONFIG
    @launch_specification = @config['launch_specification']
  end

  def create
    response = ec2_client.request_spot_instances(
      instance_count: @config['instance_count'],
      launch_specification: {
        image_id: @launch_specification['image_id'],
        instance_type: @launch_specification['instance_type'],
        key_name: @launch_specification['key_name'],
        user_data: load_user_data
      },
      spot_price: @config['spot_price'].to_s,
      type: @config['type']
    )
    resp_id = response.spot_instance_requests[0].spot_instance_request_id

    @job.update_attributes(spot_instance_request_id: resp_id)
  end

  private

  def load_user_data
    user_data = USER_DATA_FILE % {
      docker_image: @job.docker_image,
      job_id: @job.id,
      app_host: ENV.fetch('APP_HOST'),
      env_vars: env_vars_to_docker
    }
    Base64.encode64(user_data)
  end

  def env_vars_to_docker
    docker_env = []
    @job.env_vars.each do |key, value|
      docker_env << "-e #{key}=#{value}"
    end
    docker_env.join(' ')
  end

  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new
  end
end
