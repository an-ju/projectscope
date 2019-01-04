class CreateRawData < ActiveRecord::Migration[5.2]
  def change
    create_table :raw_data do |t|
      t.string :name
      t.text :content
      t.references :metric_sample, foreign_key: true

      t.timestamps
    end
  end
end
