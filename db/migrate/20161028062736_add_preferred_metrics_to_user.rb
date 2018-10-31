class AddPreferredMetricsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :preferred_metrics, :text
  end
end
