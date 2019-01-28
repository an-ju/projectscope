ProjectMetrics.configure do
  add_metric :project_metric_code_climate
  add_metric :project_metric_test_coverage
  add_metric :project_metric_travis_ci
  add_metric :project_metric_heroku_status
  add_metric :project_metric_point_distribution

  add_metric :project_metric_github_flow
  add_metric :project_metric_pull_requests
  add_metric :project_metric_github_branch
  add_metric :project_metric_tracker_activities
  add_metric :project_metric_github_use
  add_metric :project_metric_story_overall

  # add_metric :project_metric_github_files
  # add_metric :project_metric_commit_message

  add_hierarchy metric: [%I[test_coverage code_climate travis_ci heroku_status point_distribution],
                         %I[github_flow pull_requests github_branch tracker_activities github_use story_overall]]
end

METRIC_NAMES = {
  code_climate: 'Code Climate',
  test_coverage: 'Test Coverage',
  pull_requests: 'PR Status',
  # github_files: 'Edited Lines',
  github_flow: 'Commit Counting',
  travis_ci: 'Build Status',
  story_overall: 'Pivotal Tracker Use',
  point_distribution: 'Finished Stories',
  # commit_message: 'Commit Message',
  heroku_status: 'Heroku Status',
  github_use: 'GitHub Use',
  github_branch: 'Github Branch',
  tracker_activities: 'Tracker Activities'
}.freeze