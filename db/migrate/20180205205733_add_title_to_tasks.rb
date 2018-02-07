class AddTitleToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :tiitle, :string
  end
end
