class AddDataVersionToRawData < ActiveRecord::Migration[5.2]
  def change
    add_column :raw_data, :data_version, :integer
  end
end
