require 'faker'

FactoryGirl.define do
  factory :job do |f|
    f.docker_image                { Faker::App.name }
    f.scheduled_for               { Faker::Time.between(DateTime.now, DateTime.now + 2) }
    f.spot_instance_request_id    { Faker::Code.isbn }
    f.status                      'SCHEDULED'
  end
end
