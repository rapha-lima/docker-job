require 'spec_helper'

describe 'GET /list' do
  it 'should return status 200' do
    get '/list'
    expect(last_response).to be_ok
    expect(last_response.status).to eq 200
  end
end

describe 'POST /schedule' do
  let(:correct_time) { Time.now + 10 }
  let(:wrong_time) { Time.now - 10 }

  context 'successful response' do
    it 'should return status 200' do
      data = {
        docker_image: 'redis',
        scheduled_for: correct_time
      }
      post '/schedule', data.to_json
      expect(last_response.status).to eq 200
    end
  end

  context 'missing docker_image' do
    it 'should return status 400' do
      data = {
        scheduled_for: correct_time
      }
      post '/schedule', data.to_json
      expect(last_response.body).to eq({
        message: 'docker_image field cannot be empty'
      }.to_json)
      expect(last_response.status).to eq 400
    end
  end

  context 'missing scheduled_for' do
    it 'should return status 400' do
      data = {
        docker_image: 'redis'
      }
      post '/schedule', data.to_json
      expect(last_response.body).to eq({
        message: 'scheduled_for field cannot be empty'
      }.to_json)
      expect(last_response.status).to eq 400
    end
  end

  context 'wrong scheduled_for field' do
    it 'should return status 400' do
      data = {
        scheduled_for: wrong_time,
        docker_image: 'redis'
      }
      post '/schedule', data.to_json
      expect(last_response.body).to eq({
        message: "scheduled_for field must be greater than #{Time.now}"
      }.to_json)
      expect(last_response.status).to eq 400
    end
  end
end

describe 'GET /status/:id' do
  context 'successful response' do
    it 'should return status 200' do
      get '/status/1'
      expect(last_response.status).to eq 200
    end
  end

  context 'id not found' do
    it 'should return status 400' do
      job_id = '123456'
      get "/status/#{job_id}"
      expect(last_response.body).to eq({
        message: "Job id #{job_id} was not found"
      }.to_json)
      expect(last_response.status).to eq 400
    end
  end
end
