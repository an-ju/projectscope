class CreateWhitelists < ActiveRecord::Migration[4.2]
  def change
    create_table :whitelists, :force => true  do |t|
      t.string :username                  # default: "",      null: false
    end
    add_index :whitelists, :username
  end
end

