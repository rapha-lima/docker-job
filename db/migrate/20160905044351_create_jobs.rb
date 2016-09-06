# Create Jobs
class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :docker_image
      t.text :env_vars
      t.datetime :scheduled_for
      t.string :status
    end
  end
end
