FactoryBot.define do
  factory :project_issue do
    name { 'test issue' }
    sequence(:data_version) { |n| n }
  end
end