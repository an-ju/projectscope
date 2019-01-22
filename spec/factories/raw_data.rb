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
end
