class AddProjectToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :project, index: true, foreign_key: true
    add_reference :comments, :task, index: true, foreign_key: true
    add_reference :comments, :iteration, index: true, foreign_key: true
    add_column :comments, :metric, :string
  end
end
