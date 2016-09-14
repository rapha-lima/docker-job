require 'dotenv'

# Create Job
class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :docker_image
      t.datetime :scheduled_for
      t.string :status
      t.json :env_vars
    end
  end
end
