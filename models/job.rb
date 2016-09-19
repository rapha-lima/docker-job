class Job < ActiveRecord::Base
  validates :scheduled_for, :docker_image, :status, presence: true
  validates :status, inclusion: { in: %w(DONE RUNNING SCHEDULED FAILED) }
end
