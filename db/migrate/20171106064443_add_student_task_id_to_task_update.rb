class AddStudentTaskIdToTaskUpdate < ActiveRecord::Migration
  def change
    add_reference :task_updates, :student_task, index: true, foreign_key: true
  end
end
