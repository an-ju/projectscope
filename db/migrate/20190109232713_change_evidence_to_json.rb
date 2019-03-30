class ChangeEvidenceToJson < ActiveRecord::Migration[5.2]
  def change
    change_column :project_issues, :evidence, :jsonb, using: 'column_name::text::jsonb'
  end
end
