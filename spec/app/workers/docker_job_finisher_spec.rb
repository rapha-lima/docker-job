require 'spec_helper'

RSpec.describe DockerJobFinisher do
  let(:job) { create :job }

  it 'enqueue a job with job_id' do
    expect { described_class.perform_async(job.id) }.to change { described_class.jobs.size }.by(1)
  end
end
