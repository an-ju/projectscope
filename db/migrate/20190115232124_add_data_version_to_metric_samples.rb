class AddDataVersionToMetricSamples < ActiveRecord::Migration[5.2]
  def change
    add_column :metric_samples, :data_version, :integer
  end
end
