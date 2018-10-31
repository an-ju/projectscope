class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.string :name
      t.timestamps null: false
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :template
    end
  end
end