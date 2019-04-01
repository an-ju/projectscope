class ChangeContentColumnOfRawData < ActiveRecord::Migration[5.2]
  def change
    change_column :raw_data, :content, :jsonb, using: 'content::jsonb'
  end
end
