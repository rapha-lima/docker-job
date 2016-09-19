require 'spec_helper'

RSpec.describe JobStatus do
  it 'has a valid key done' do
    expect(described_class.done).to eq('DONE')
  end

  it 'has a valid key failed' do
    expect(described_class.failed).to eq('FAILED')
  end

  it 'has a valid key scheduled' do
    expect(described_class.scheduled).to eq('SCHEDULED')
  end

  it 'has a valid key running' do
    expect(described_class.running).to eq('RUNNING')
  end
end
