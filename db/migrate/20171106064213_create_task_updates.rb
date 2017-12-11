class CreateTaskUpdates < ActiveRecord::Migration
  def change
    create_table :task_updates do |t|
      t.string :before
      t.string :after

      t.timestamps null: false
    end
  end
end
