class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :task_status
      t.integer :duration
      t.string :task_callbacks
      t.string :updater_type
      t.datetime :update_time
      t.string :updater_info
    end
  end
end