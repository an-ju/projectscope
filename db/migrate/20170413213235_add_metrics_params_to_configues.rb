class AddMetricsParamsToConfigues < ActiveRecord::Migration[4.2]
  def change
    add_column :configs, :metrics_params, :string
    add_column :configs, :token, :string
  end
end
