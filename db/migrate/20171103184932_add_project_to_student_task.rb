class AddProjectToStudentTask < ActiveRecord::Migration
  def change
    add_reference :student_tasks, :project, index: true, foreign_key: true
  end
end
