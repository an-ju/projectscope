FactoryBot.define do

  factory :config do
    token { 'test' }
  end

  factory :config_github_project, class: Config do
    token { 'https://github.com/test/test' }
    metrics_params { 'github_project' }
  end

  factory :config_cc_token, class: Config do
    token { 'test' }
    metrics_params { 'codeclimate_token' }
  end
end