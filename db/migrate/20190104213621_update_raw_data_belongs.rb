class UpdateRawDataBelongs < ActiveRecord::Migration[5.2]
  def change
    remove_column :raw_data, :metric_sample_id
    add_reference :raw_data, :project, index: true
  end
end
