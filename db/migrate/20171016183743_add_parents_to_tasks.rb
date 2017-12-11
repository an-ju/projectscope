class AddParentsToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :task, index: true, foreign_key: true

  end
end
