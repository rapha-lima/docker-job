require 'spec_helper'

RSpec.describe DockerJobInitializer do
  let(:job) { create :job }

  it 'enqueue a job' do
    expect { described_class.perform_async(job.id) }.to change { described_class.jobs.size }.by(1)
  end
end
