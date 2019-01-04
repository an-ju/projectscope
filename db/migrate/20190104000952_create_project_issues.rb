class CreateProjectIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :project_issues do |t|
      t.string :name
      t.text :evidence
      t.text :content
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
