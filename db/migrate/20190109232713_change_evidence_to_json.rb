class ChangeEvidenceToJson < ActiveRecord::Migration[5.2]
  def change
    change_column :project_issues, :evidence, :jsonb, using: 'evidence::jsonb'
  end
end
