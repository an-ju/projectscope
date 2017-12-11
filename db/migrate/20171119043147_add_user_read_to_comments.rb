class AddUserReadToComments < ActiveRecord::Migration
  def change
    add_column :comments, :admin_read, :string
    add_column :comments, :student_read, :string
  end
end
