require 'spec_helper'

RSpec.describe App do
  let(:job) { create :job }
  let(:job_status) { Job.find(job.id).status }

  describe 'GET /list' do
    it 'when called' do
      get '/list'
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end
  end

  describe 'POST /schedule' do
    let(:correct_time) { 2.minutes.from_now }
    let(:wrong_time) { 2.minutes.ago }

    context 'successful response' do
      let(:body) { { docker_image: 'redis', scheduled_for: correct_time }.to_json }
      it 'when called' do
        post '/schedule', body, 'Content-Type' => 'application/json'
        expect(last_response.status).to eq 200
      end
    end

    context 'missing docker_image' do
      let(:body) { { scheduled_for: correct_time }.to_json }
      it 'when called' do
        post '/schedule', body
        expect(last_response.body).to eq({ message: 'docker_image field cannot be empty' }.to_json)
        expect(last_response.status).to eq 400
      end
    end

    context 'missing scheduled_for' do
      let(:body) { { docker_image: 'redis' }.to_json }
      it 'when called' do
        post '/schedule', body
        expect(last_response.body).to eq({ message: 'scheduled_for field cannot be empty' }.to_json)
        expect(last_response.status).to eq 400
      end
    end

    context 'wrong scheduled_for field' do
      let(:body) { { scheduled_for: wrong_time, docker_image: 'redis' }.to_json }
      it 'when called' do
        post '/schedule', body
        expect(last_response.body).to eq({ message: "scheduled_for field must be greater than #{1.minutes.from_now}" }.to_json)
        expect(last_response.status).to eq 400
      end
    end
  end

  describe 'GET /status/:id' do
    context 'successful response' do
      it 'when called' do
        get "/status/#{job.id}"
        expect(last_response.status).to eq 200
      end
    end

    context 'id not found' do
      let(:job_id) { Faker::Number.number(4) }
      it 'when called' do
        get "/status/#{job_id}"
        expect(last_response.body).to eq({ message: "Job id #{job_id} was not found" }.to_json)
        expect(last_response.status).to eq 400
      end
    end
  end

  describe 'PUT /callback/:id' do
    context 'with schedule param on body' do
      let(:body) { { schedule: '' }.to_json }
      it 'when called' do
        put "/callback/#{job.id}", body
        expect(last_response.status).to eq 200
      end

      it { expect(job_status).to eq('SCHEDULED') }
    end

    context 'with failed param on body' do
      let(:body) { { failed: '', error_message: '' }.to_json }
      it 'when called' do
        put "/callback/#{job.id}", body
        expect(last_response.status).to eq 200
        expect(job_status).to eq('FAILED')
      end
    end

    context 'without any param on body' do
      let(:body) { {}.to_json }
      it 'when called' do
        put "/callback/#{job.id}", body
        expect(last_response.status).to eq 200
        expect(job_status).to eq('DONE')
      end
    end
  end
end
