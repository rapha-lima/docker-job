require 'spec_helper'

RSpec.describe Configuration do
  it 'has a valid key spot_price' do
    expect(described_class.spot_price).to be_a(String)
  end

  it 'has a valid key type' do
    expect(described_class.type).to be_a(String)
  end

  it 'has a valid key instance_count' do
    expect(described_class.instance_count).to be_a(Integer)
  end

  describe 'launch_specification has valid keys' do
    before :each do
      @conf = described_class.launch_specification
    end

    it 'has a valid key image_id' do
      expect(@conf.image_id).to be_a(String)
    end

    it 'has a valid key instance_type' do
      expect(@conf.instance_type).to be_a(String)
    end

    it 'has a valid key key_name' do
      expect(@conf.key_name).to be_a(String)
    end
  end
end
