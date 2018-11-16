ProjectMetrics.configure do
  add_metric :project_metric_code_climate
  add_metric :project_metric_story_overall
  add_metric :project_metric_test_coverage
  add_metric :project_metric_pull_requests
  add_metric :project_metric_travis_ci
  add_metric :project_metric_github_files
  add_metric :project_metric_github_flow
  add_metric :project_metric_github_use
  add_metric :project_metric_point_distribution
  add_metric :project_metric_smart_story
  add_metric :project_metric_commit_message
  add_metric :project_metric_heroku_status

  add_hierarchy metric: [%I[test_coverage code_climate travis_ci heroku_status point_distribution],
                         %I[pull_requests github_use github_flow smart_story story_overall]]
end

METRIC_NAMES = {
  code_climate: 'Code Climate',
  test_coverage: 'Test Coverage',
  pull_requests: 'PR Status',
  github_files: 'Edited Lines',
  github_flow: 'Commit Counting',
  travis_ci: 'Build Status',
  smart_story: 'Story Relevance',
  story_overall: 'Story Status',
  point_distribution: 'Finished Stories',
  commit_message: 'Commit Message',
  heroku_status: 'Heroku Status',
  github_use: 'GitHub Usage'
}.freeze