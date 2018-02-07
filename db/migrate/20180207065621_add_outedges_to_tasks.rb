class AddOutedgesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :outedges, :jsonb
  end
end
