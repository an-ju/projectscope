class ProjectIssue < ApplicationRecord
  belongs_to :project

  ISSUES = %I[test_coverage_drop maintainability_drop].freeze

  def self.test_coverage_drop(project, version)
    report_curr = project.data_at('codeclimate_report', version)
    report_prev = project.data_before('codeclimate_report', version)

    return if report_curr.nil? or report_prev.nil?

    v1 = report_curr.test_coverage
    v2 = report_prev.test_coverage
    if v2 - v1 > 0
      create( project: project,
              name: 'test_coverage_drop',
              content: "Test coverage drops from #{v2} to #{v1}.",
              evidence: { curr: report_curr.id, prev: report_prev.id })
    end
  end

  def self.low_test_coverage(project, version)
    report_curr = project.data_at('codeclimate_report', version)
    return if report_curr.nil?

    v_curr = report_curr.test_coverage
    if v_curr < 80
      create( project: project,
              name: 'low_test_coverage',
              content: "Test coverage is at #{v_curr}.",
              evidence: { curr: v_curr })
    end
  end

  def self.maintainability_drop(project, version)
    snapshot_curr = project.data_at('codeclimate_snapshot', version)
    snapshot_prev = project.data_before('codeclimate_snapshot', version)

    return if snapshot_curr.nil? or snapshot_prev.nil?

    v1 = snapshot_curr.tech_debt
    v2 = snapshot_prev.tech_debt

    if v2 - v1 < 0
      create( project: project,
              name: 'maintainability_drop',
              content: "Technical debt grows from #{v2}% to #{v1}%.",
              evidence: { curr: snapshot_curr.id, prev: snapshot_prev.id })
    end
  end

end
