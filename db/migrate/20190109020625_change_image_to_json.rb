class ChangeImageToJson < ActiveRecord::Migration[5.2]
  def change
    change_column :metric_samples, :image, :jsonb, using: 'image::jsonb'
  end
end
