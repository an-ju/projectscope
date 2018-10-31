class AddActiveToIterations < ActiveRecord::Migration[4.2]
  def change
    add_column :iterations, :active, :boolean
  end
end
