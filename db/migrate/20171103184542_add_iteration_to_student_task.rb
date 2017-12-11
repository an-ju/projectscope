class AddIterationToStudentTask < ActiveRecord::Migration
  def change
    add_reference :student_tasks, :iteration, index: true, foreign_key: true
  end
end
