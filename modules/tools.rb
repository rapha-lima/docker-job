# modules/tools.rb
module Tools
  def validate_time
    message = "scheduled_for field must be greater than #{Time.now}"
    halt 400, message: message if @response_body[:scheduled_for] < 1.minutes.from_now
  end

  def validate_status_params(job)
    halt 400, message: "Job id #{@response_body[:id]} was not found" if job.nil? || job.empty?
  end

  def validate_schedule_params
    halt 400, message: 'docker_image field cannot be empty' if @response_body[:docker_image].nil? || @response_body[:docker_image].empty?
    halt 400, message: 'scheduled_for field cannot be empty' if @response_body[:scheduled_for].nil? || @response_body[:scheduled_for].empty?
  end
end
