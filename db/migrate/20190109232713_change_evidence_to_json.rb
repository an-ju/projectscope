class ChangeEvidenceToJson < ActiveRecord::Migration[5.2]
  def change
    change_column :project_issues, :evidence, :json
  end
end
