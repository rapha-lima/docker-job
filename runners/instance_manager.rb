require 'aws-sdk'
require 'base64'

class InstanceManager
  USER_DATA_FILE = File.read('config/templates/bootstrap.txt').freeze

  attr_accessor :docker_image, :env_vars, :job_id

  def initialize(docker_image:, env_vars:, job_id:)
    @docker_image = docker_image
    @env_vars = env_vars
    @job_id = job_id
  end

  def create
    response = ec2_client.request_spot_instances(
      instance_count: 1,
      launch_specification: {
        image_id: 'ami-6bb2d67c',
        instance_type: 'm3.medium',
        key_name: 'ecs-raphinha',
        user_data: load_user_data
      },
      spot_price: '0.035',
      type: 'one-time'
    )
    response.spot_instance_requests[0].spot_instance_request_id.to_json
  end

  private

  def load_user_data
    user_data = USER_DATA_FILE % {
      docker_image: @docker_image,
      job_id: @job_id,
      app_host: ENV['APP_HOST'],
      env_vars: @env_vars.gsub(' ', ' -e ')
    }
    Base64.encode64(user_data)
  end

  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new
  end
end
