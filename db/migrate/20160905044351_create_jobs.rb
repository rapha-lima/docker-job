require 'dotenv'

# Create Job
class CreateJobs < ActiveRecord::Migration
  def change
    create_table  :jobs do |t|
      t.string    :docker_image
      t.json      :env_vars
      t.datetime  :scheduled_for
      t.string    :spot_instance_request_id
      t.string    :status
    end
  end
end
