# require 'spec_helper'
#
# TODO: Need to fix this spec, it's not working yet.
#
# RSpec.describe SpotInstanceManager do
#   let(:job) { create :job }
#   subject(:service) { described_class.new(job.id) }
#
#   let(:spot_instance_request_id) { 'sdf-qwer123' }
#
#   describe '#create' do
#     subject do
#       service.create
#     end
#
#     let(:ec2_client) { double }
#
#     before do
#       allow(service).to receive(:ec2_client).with(no_args).and_return(ec2_client)
#       allow(ec2_client).to receive(:request_spot_instances).and_return(spot_instance_request_id)
#     end
#
#     it 'resquest spot instance' do
#       subject
#
#       expect(ec2_client).to have_received(:request_spot_instances)
#     end
#   end
# end
