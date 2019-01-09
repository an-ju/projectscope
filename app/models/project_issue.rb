class ProjectIssue < ApplicationRecord
  belongs_to :project

  def self.issues
    %I[test_coverage_drop]
  end

  def test_coverage_drop(project)
    project.test_reports
  end

end
