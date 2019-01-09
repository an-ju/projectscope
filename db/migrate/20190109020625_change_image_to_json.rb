class ChangeImageToJson < ActiveRecord::Migration[5.2]
  def change
    change_column :metric_samples, :image, :json
  end
end
