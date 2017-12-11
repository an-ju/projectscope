class AddStatusToStudentTask < ActiveRecord::Migration
  def change
    add_column :student_tasks, :status, :string, :default =>"In Screen"
  end
end
