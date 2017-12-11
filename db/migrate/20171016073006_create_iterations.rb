class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.string :name
      t.date :start
      t.date :end
      t.integer :tasks_id

      t.timestamps null: false
    end
  end
end
