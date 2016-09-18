module Tools
  def validate_time
    message = "scheduled_for field must be greater than #{1.minutes.from_now}"
    halt 400, { message: message }.to_json if @response_body[:scheduled_for] < 1.minutes.from_now
  end

  def validate_status_params(job)
    halt 400, { message: "Job id #{params[:id]} was not found" }.to_json if job.nil? || job.empty?
  end

  def validate_schedule_params
    halt 400, { message: 'docker_image field cannot be empty' }.to_json if @response_body[:docker_image].nil? || @response_body[:docker_image].empty?
    halt 400, { message: 'scheduled_for field cannot be empty' }.to_json if @response_body[:scheduled_for].nil? || @response_body[:scheduled_for].empty?
  end

  def verify_callback_failed_param
    if @response_body[:failed]
      @job.update_attributes(status: JobStatus.failed, error_message: @response_body[:error_message])
    else
      @job.update_attributes(status: JobStatus.done)
    end
  end

  def load_body
    content_type :json
    response_body = JSON.load(request.body.read.to_s)
    @response_body = response_body.symbolize_keys
  end

  def parse_time
    @response_body[:scheduled_for] = Time.parse(@response_body[:scheduled_for])
  end
end
