require 'spec_helper'

RSpec.describe Job do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:job)).to be_valid
  end

  describe 'validate presence values' do
    before :each do
      @docker_image = FactoryGirl.build(:job, docker_image: nil)
      @scheduled_for = FactoryGirl.build(:job, scheduled_for: nil)
      @status = FactoryGirl.build(:job, status: nil)
      @invalid_status = FactoryGirl.build(:job, status: 'DAMN')
    end

    it 'is invalid without a docker_image' do
      expect(@docker_image).to_not be_valid
    end

    it 'is invalid without a scheduled_for' do
      expect(@scheduled_for).to_not be_valid
    end

    it 'is invalid without a status' do
      expect(@status).to_not be_valid
    end

    it 'is invalid with a wrong value' do
      expect(@invalid_status).to_not be_valid
    end
  end
end
