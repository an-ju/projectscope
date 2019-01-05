require 'rails_helper'
require 'support/metric_generator'

RSpec.configure do |config|
  config.include MetricGenerator
end

describe RawData, type: :model do
  describe 'self.register' do
    before :each do
      @project = create(:project)
    end

    it 'creates a new raw_data record from given metric_sample' do
      metric_sample = double('metric', raw_data: { test: { data: 'test data'} } )
      expect { described_class.register(@project, metric_sample) }.to change { RawData.count }.by(1)
    end

    it 'collects all data from metric_sample' do
      metric_sample = double('metric',
                            raw_data: { test1: { data: 'data 1'},
                                        test2: { data: 'data 2'} } )
      expect { described_class.register(@project, metric_sample) }.to change { RawData.count }.by(2)
    end

    it 'does not create new item for stored data' do
      metric_sample = double('metric',
                             raw_data: { test: { data: 'test data' }})
      create(:raw_data, project: @project, name: :test, data_version: 0)
      expect { described_class.register(@project, metric_sample, 0) }.not_to change { RawData.count }
    end
  end

  describe 'self.get_data_for' do
    before :each do
      @project = create(:project)
      create(:raw_data, project: @project, name: 'test 1', data_version: 0)
      create(:raw_data, project: @project, name: 'test 2', data_version: 0)

      @test_class = double('test project metric')
      allow(ProjectMetrics).to receive(:class_for).and_return(@test_class)
    end

    it 'returns data if it has been stored' do
      allow(@test_class).to receive(:meta).and_return({ raw_data: ['test 1', 'test 2'] })
      expect(@project.raw_data.get_data_for('test', 0).length).to eql(2)
    end

    it 'returns partial data' do
      allow(@test_class).to receive(:meta).and_return({ raw_data: ['test 1', 'test 3'] })
      expect(@project.raw_data.get_data_for('test', 0).length).to eql(1)
    end

    it 'returns empty data when version is wrong' do
      allow(@test_class).to receive(:meta).and_return({ raw_data: ['test 1', 'test 2'] })

      expect(@project.raw_data.get_data_for('test', 1).length).to eql(0)
    end
  end

end