class AddProjectToIteration < ActiveRecord::Migration[4.2]
  def change
    add_reference :iterations, :project, index: true, foreign_key: true
  end
end