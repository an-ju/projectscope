class AddStudentTaskToStudentTask < ActiveRecord::Migration
  def change
    add_reference :student_tasks, :student_task, index: true, foreign_key: true
  end
end
