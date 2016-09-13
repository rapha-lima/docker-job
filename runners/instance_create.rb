require 'aws-sdk'
require 'base64'

# Class to create instance on AWS
class InstanceCreate
  USER_DATA_FILE = IO.read('config/templates/bootstrap.txt').freeze

  attr_accessor :docker_image, :env_vars, :job_id

  def initialize(docker_image, env_vars, job_id)
    @docker_image = docker_image
    @env_vars = env_vars
    @job_id = job_id

    load_aws_config
  end

  def run
    ec2 = Aws::EC2::Client.new
    resp = ec2.request_spot_instances(
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
    resp.spot_instance_requests[0].spot_instance_request_id.to_json
  end

  private

  def load_aws_config
    Aws.config.update(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )
    )
  end

  def load_user_data
    user_data = USER_DATA_FILE % {
      docker_image: @docker_image,
      job_id: @job_id,
      app_host: ENV['APP_HOST'],
      env_vars: @env_vars.gsub(' ', ' -e ')
    }
    Base64.encode64(user_data)
  end
end
