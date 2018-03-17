class CreateUpdaters < ActiveRecord::Migration
  def change
    create_table :updaters do |t|
      t.references :task, index: true
      t.string :updater_type
      t.timestamps null: false
    end
  end
end
