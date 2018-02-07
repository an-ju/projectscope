class AddInedgesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :inedges, :jsonb
  end
end
