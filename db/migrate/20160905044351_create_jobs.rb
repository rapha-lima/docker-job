# Create Jobs
class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :docker_image
      t.string :scheduled_for
      t.string :status
    end
  end
end
