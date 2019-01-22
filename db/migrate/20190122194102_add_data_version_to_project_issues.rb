class AddDataVersionToProjectIssues < ActiveRecord::Migration[5.2]
  def change
    add_column :project_issues, :data_version, :integer
  end
end
