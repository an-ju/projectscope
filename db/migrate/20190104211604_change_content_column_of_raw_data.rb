class ChangeContentColumnOfRawData < ActiveRecord::Migration[5.2]
  def change
    change_column :raw_data, :content, :json
  end
end
