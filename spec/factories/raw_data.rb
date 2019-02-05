FactoryBot.define do

  factory :raw_data do
    name { 'test' }
    sequence(:data_version) { |n| n }
    content { { value: 'test' } }
  end

  factory :codeclimate_report, class: RawData do
    name { 'codeclimate_report' }
    sequence(:content) do |n|
      jstr = File.read 'spec/fixtures/files/raw_data/codeclimate_report.json'
      JSON.parse(jstr % { coverage: 80 - n * 10})
    end
    sequence(:data_version) { |n| n }
  end

  factory :codeclimate_snapshot, class: RawData do
    name { 'codeclimate_snapshot' }
    sequence(:content) do |n|
      jstr = File.read 'spec/fixtures/files/raw_data/snapshot.json'
      JSON.parse(jstr % { tech_debt: 10 * n})
    end
    sequence(:data_version) { |n| n }
  end

  factory :tracker_memberships, class: RawData do
    name { 'tracker_memberships' }
    sequence(:data_version) { |n| n }
  end

  factory :tracker_stories, class: RawData do
    name { 'tracker_stories' }
    sequence(:data_version) { |n| n }
  end

  factory :github_branches, class: RawData do
    name { 'github_branches' }
    sequence(:data_version) { |n| n }
  end

  factory :github_events, class: RawData do
    name { 'github_events' }
    sequence(:data_version) { |n| n }
  end
end
