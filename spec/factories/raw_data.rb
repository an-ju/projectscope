FactoryBot.define do

  factory :codeclimate_report, class: RawData do
    name { 'codeclimate_report' }
    sequence(:content) do |n|
      jstr = File.read 'spec/fixtures/files/raw_data/codeclimate_report.json'
      JSON.parse(jstr % { coverage: 80 - n * 10})
    end
    sequence(:data_version) { |n| n }
  end
end
