require 'aws-sdk'
require 'base64'

class InstanceManager
  USER_DATA_FILE = File.read('config/templates/bootstrap.txt').freeze

  attr_accessor :job_id

  def initialize(job_id)
    @job = Job.find(job_id)
  end

  def create
    response = ec2_client.request_spot_instances(
      instance_count: Configuration.instance_count,
      launch_specification: {
        image_id: Configuration.launch_specification.image_id,
        instance_type: Configuration.launch_specification.instance_type,
        key_name: Configuration.launch_specification.key_name,
        user_data: load_user_data
      },
      spot_price: Configuration.spot_price,
      type: Configuration.type
    )
    spot_instance_request_id = response.spot_instance_requests[0].spot_instance_request_id

    @job.update_attributes(
      spot_instance_request_id: spot_instance_request_id
    )
  end

  def remove
    response = ec2_client.describe_spot_instance_requests(spot_instance_request_ids: [@job.spot_instance_request_id])
    instance_id = response.spot_instance_requests[0].instance_id

    ec2_client.cancel_spot_instance_requests(spot_instance_request_ids: [@job.spot_instance_request_id])
    ec2_client.terminate_instances(instance_ids: [instance_id])
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
    @job.env_vars.map { |key, value| "-e #{key}=#{value}" }.join(' ')
  end

  def ec2_client
    @ec2_client ||= Aws::EC2::Client.new
  end
end
