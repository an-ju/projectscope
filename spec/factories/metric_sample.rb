FactoryBot.define do
  factory :project_metric_travis_ci, class: MetricSample do
    metric_name { 'travis_ci' }
    sequence(:data_version) { |n| n }
  end

  factory :project_metric_heroku_status, class: MetricSample do
    metric_name { 'heroku_status' }
    sequence(:data_version) { |n| n }
  end
end