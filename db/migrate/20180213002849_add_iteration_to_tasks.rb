class AddIterationToTasks < ActiveRecord::Migration[4.2]
  def change
    add_reference :tasks, :iteration, index: true, foreign_key: true
  end
end