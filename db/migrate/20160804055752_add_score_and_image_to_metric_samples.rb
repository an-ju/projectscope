class AddScoreAndImageToMetricSamples < ActiveRecord::Migration[4.2]
  def change
    add_column :metric_samples, :score, :float
    add_column :metric_samples, :image, :text
  end
end
