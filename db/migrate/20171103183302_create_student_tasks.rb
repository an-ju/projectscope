class CreateStudentTasks < ActiveRecord::Migration
  def change
    create_table :student_tasks do |t|
      t.string :title
      t.string :description

      t.timestamps null: false
    end
  end
end
