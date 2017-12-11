class CommentsToStudentTaskInsteadOfTask < ActiveRecord::Migration
  def change
    rename_column :comments, :task_id, :student_task_id
  end
end
