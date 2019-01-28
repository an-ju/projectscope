class ProjectIssue < ApplicationRecord
  belongs_to :project

  ISSUES = %I[test_coverage_drop maintainability_drop].freeze

  def self.test_coverage_drop(project, version1, version2)
    report_curr = project.data_at('codeclimate_report', version1)
    report_prev = project.data_at('codeclimate_report', version2)

    return if report_curr.nil? or report_prev.nil?

    v1 = report_curr.test_coverage
    v2 = report_prev.test_coverage
    if v2 - v1 > 0
      create( project: project,
              name: 'test_coverage_drop',
              content: "Test coverage drops from #{v2} to #{v1}.",
              data_version: version1,
              evidence: { curr: report_curr.id, prev: report_prev.id })
    end
  end

  def self.low_test_coverage(project, version, _)
    report_curr = project.data_at('codeclimate_report', version)
    return if report_curr.nil?

    v_curr = report_curr.test_coverage
    if v_curr < 80
      create( project: project,
              name: 'low_test_coverage',
              content: "Test coverage is at #{v_curr}.",
              data_version: version,
              evidence: { curr: v_curr })
    end
  end

  def self.maintainability_drop(project, version1, version2)
    snapshot_curr = project.data_at('codeclimate_snapshot', version1)
    snapshot_prev = project.data_at('codeclimate_snapshot', version2)

    return if snapshot_curr.nil? or snapshot_prev.nil?

    v1 = snapshot_curr.tech_debt
    v2 = snapshot_prev.tech_debt

    if v2 - v1 < 0
      create( project: project,
              name: 'maintainability_drop',
              content: "Technical debt grows from #{v2}% to #{v1}%.",
              data_version: version1,
              evidence: { curr: snapshot_curr.id, prev: snapshot_prev.id })
    end
  end

  def self.breaking_travis(project, version, _)
    curr = project.metric_samples.find_by(metric_name: 'travis_ci', data_version: version)

    return if curr.nil?

    curr_status = curr.image['data']['builds'].first['state']
    unless curr_status.eql? 'passed'
      create( project: project,
              name: 'breaking_travis',
              content: "Travis CI status: #{curr_status}",
              data_version: version,
              evidence: { curr: curr.id } )
    end
  end

  def self.no_new_deployment(project, version, _)
    curr = project.metric_samples.find_by(metric_name: 'heroku_status', data_version: version)

    return if curr.nil?

    latest_release = curr.image['data']['release'].first
    is_new = Date.parse(latest_release['created_at']) > project.current_iteration.start_time
    curr_status = latest_release['status']

    if is_new
      unless curr_status.eql? 'succeeded'
        create( project: project,
                name: 'failed_heroku',
                content: "Latest Heroku release status: #{curr_status}",
                data_version: version,
                evidence: { curr: curr.id })
      end
    else
      create( project: project,
              name: 'no_heroku_release',
              content: "Could not find new Heroku release.",
              data_version: version,
              evidence: { curr: curr.id })
    end
  end

  def self.heroku_not_accessible(project, version, _)
    curr = project.metric_samples.find_by(metric_name: 'heroku_status', data_version: version)
    return if curr.nil?

    web_status = curr.image['data']['web_status']
    if web_status >= 400
      create( project: project,
              name: 'webpage_not_accessible',
              content: "Access to Heroku app has status: #{web_status}",
              data_version: version,
              evidence: { curr: curr.id })
    end
  end

  def self.unfinished_backlog(project, version, _)
    curr = project.metric_samples.find_by(metric_name: 'point_distribution', data_version: version)
    return if curr.nil?

    planned = curr.image['data']['planned']
    started = curr.image['data']['started']
    finished = curr.image['data']['finished']
    if planned.length > 0
      create( project: project,
              name: 'unfinished_backlog',
              content: "Story planned but not finished: #{planned.length}",
              data_version: version,
              evidence: { curr: curr.id })
    end

    if started.length > 0
      create( project: project,
              name: 'unfinished_backlog',
              content: "Story started but not finished: #{started.length}",
              data_version: version,
              evidence: { curr: curr.id })
    end

    if finished.length > 0
      create( project: project,
              name: 'unfinished_backlog',
              content: "Story finished but not delivered: #{finished.length}",
              data_version: version,
              evidence: { curr: curr.id })
    end
  end

end
