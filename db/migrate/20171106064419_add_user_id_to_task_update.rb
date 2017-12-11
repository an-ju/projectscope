class AddUserIdToTaskUpdate < ActiveRecord::Migration
  def change
    add_reference :task_updates,:user, index: true, foreign_key: true
  end
end
