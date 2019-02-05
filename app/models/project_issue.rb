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

  def self.backlog_change_activities(project, version, _)
    curr = project.metric_samples.find_by(metric_name: 'tracker_activities', data_version: version)
    return if curr.nil?

    backlog_change = curr.image['data']['activities']
    backlog_change = backlog_change.select do |el|
      el['changes'].any? { |ch| (ch['new_values'].key? 'before_id') || (ch['new_values'].key? 'after_id')}
    end
    if backlog_change.length > 0
      create( project: project,
              name: 'backlog_change',
              content: "The backlog is changed #{backlog_change.length} times in the past three days.",
              data_version: version,
              evidence: { curr: curr.id })
    end
  end

  def self.fast_story_transition(project, v1, v2)
    raw_data = project.raw_data.where("name=? AND data_version >= ? AND data_version <= ?",
                                      'tracker_activities', v2, v1)
    update_activities = raw_data.flat_map { |el| el.content }
                            .uniq { |el| el['guid'] }
                            .select { |el| el['kind'].eql? 'story_update_activity' }
    stories_activities = update_activities.group_by { |act| act['primary_resources'].first['id'] }
    stories_dev_time = stories_activities.each do |s, events|

    end
  end

  def self.no_slacking_tracker(project, v1, v2)
    curr = project.metric_samples.find_by(metric_name: 'point_distribution', data_version: v1)
    prev = project.metric_samples.find_by(metric_name: 'point_distribution', data_version: v2)
    memb = project.raw_data.find_by(name: 'tracker_memberships', data_version: v1)
    memberships = memb.content
    uids = memberships.map { |usr| usr['id'] }
    return if curr.nil? or prev.nil?

    curr_stories = curr.image['data']['delivered']
    prev_sids = prev.image['data']['delivered'].map { |el| el['id'] }
    new_stories = curr_stories.reject { |el| prev_sids.include? el['id'] }

    authors = new_stories.flat_map { |el| el['owner_ids'] }

    uids = uids.reject { |uid| authors.include? uid }
    uids.each do |uid|
      uname = memberships.find { |usr| usr['id'].eql? uid }['person']['name']
      create( project: project,
              name: 'slacking',
              content: "No delivered stories found from user #{uname}.",
              data_version: v1,
              evidence: { curr: curr.id, prev: prev.id, members: memb.id })
    end
  end

  def self.branch_name(project, v1, v2)
    metrics = project.raw_data.where("name=? AND data_version >= ? AND data_version <= ?",
                                     'github_branches', v2, v1)
    story_data = project.raw_data.find_by(name: 'tracker_stories', data_version: v1)
    sids = story_data.content.map { |s| s['id'].to_i }

    commit_shas = {}
    all_branches = metrics.flat_map(&:content).uniq { |br| br['commit']['sha'] }
    name_pattern = /^(\d+).*$/
    bad_branches = all_branches.reject do |br|
      match =  name_pattern.match(br['name'])
      match.nil? ? false : (sids.include? match[0].to_i)
    end

    bad_branches.each do |br|
      create( project: project,
              name: 'branch_name',
              content: "Branch name does not specify a story: #{br['name']}",
              data_version: v1,
              evidence: { curr: br, story_ids: sids })
    end
  end

  def self.story_cycle_time(project, v1, v2)
    metric = project.metric_samples.find_by(metric_name: 'cycle_time', data_version: v1)
    prev_metric = project.metric_samples.find_by(metric_name: 'cycle_time', data_version: v2)
    return if metric.nil? or prev_metric.nil?

    prev_stories = prev_metric.image['data']['delivered_stories'].map { |el| el['id'] }
    stories = metric.image['data']['delivered_stories']
    stories.reject { |el| prev_stories.include? el['id'] }.each do |s|
      cycle_time = s['cycle_time_details']['total_cycle_time'] - s['cycle_time_details']['delivered_time']
      if cycle_time < 3600 * 1000
        create( project: project,
                name: 'short_cycle_time',
                content: "Cycle time of story #{s['name']}(#{s['id']}) is less than 1 hour.",
                data_version: v1,
                evidence: { curr: metric.id } )
      end

      if cycle_time > 5 * 24 * 3600 * 1000
        create( project: project,
                name: 'long_cycle_time',
                content: "Cycle time of story #{s['name']}(#{s['id']}) is longer than 5 days.",
                data_version: v1,
                evidence: { curr: metric.id })
      end
    end
  end

  def self.pr_comments(project, v1, v2)
    raw_data = project.raw_data.where('name=? AND data_version >= ? AND data_version <= ?',
                                      'github_events', v2, v1)
    pr_events = raw_data.flat_map(&:content)
                  .select { |event| event['type'].eql? 'PullRequestEvent' }
                  .uniq { |event| event['id'] }
    pr_events.select { |event| event['payload']['action'].eql? 'closed' }.each do |event|
      if event['payload']['pull_request']['comments'] < 1
        create( project: project,
                name: 'pr_comments',
                content: "Pull request #{event['payload']['number']} is closed without a comment.",
                data_version: v1,
                evidence: { pr_events: pr_events })
      end
    end

  end

end
