class AddProjectIndexToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :project, index: true, foreign_key: true
  end
end
