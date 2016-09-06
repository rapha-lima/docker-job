# Validates jobs table
class Jobs < ActiveRecord::Base
  validates_presence_of :scheduled_for
  validates_presence_of :docker_image
  validates_presence_of :status
end
