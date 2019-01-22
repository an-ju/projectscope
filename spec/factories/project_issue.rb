FactoryBot.define do
  factory :project_issue do
    name { 'test issue' }
    content { 'This is a test issue.' }
    sequence(:data_version) { |n| n }
    evidence { { curr: 'test1', prev: 'test2'} }
  end
end