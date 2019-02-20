# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'rails_helper'
require 'support/metric_generator'

RSpec.configure do |config|
  config.include MetricGenerator
end

describe Project do
  describe 'resample_all_metrics' do
    before :each do
      @project = create(:project)
    end

    it 'uses the right data version' do
      metric_names = ProjectMetrics.metric_names
      create(:raw_data, project: @project, data_version: 1)
      expect(@project).to receive(:resample_metric).with(anything, 2).exactly(metric_names.length).times
      @project.resample_all_metrics
    end

    context 'using real metrics' do
      before :each do
        create( :config_github_project,
                metric_name: 'code_climate',
                project: @project )
        create( :config_cc_token,
                metric_name: 'code_climate',
                project: @project )
        create( :config_github_project,
                metric_name: 'test_coverage',
                project: @project )
        create( :config_cc_token,
                metric_name: 'test_coverage',
                project: @project )

        @req_project = stub_request(:get, "https://api.codeclimate.com/v1/repos?github_slug=test/test").
            with( headers: { 'Authorization'=>'Token token=test' }).
            to_return(status: 200, body: file_fixture('project.json'))
        stub_request(:get, "https://api.codeclimate.com/v1/repos/696a76232df2736347000001/snapshots/596a762c9373ca000100177e").
            with( headers: { 'Authorization'=>'Token token=test' }).
            to_return(status: 200, body: file_fixture('snapshot.json'))
        stub_request(:get, "https://api.codeclimate.com/v1/repos/696a76232df2736347000001/test_reports").
            with( headers: { 'Authorization'=>'Token token=test' }).
            to_return(status: 200, body: file_fixture('reports.json'))
        stub_request(:get, "https://api.codeclimate.com/v1/repos/696a76232df2736347000001/test_reports/596ad7629c5b3756bc000003/test_file_reports?page%5Bsize%5D=100").
            to_return(status: 200, body: file_fixture('page1.json'))
        stub_request(:get, "https://api.codeclimate.com/v1/repos/696a76232df2736347000001/test_reports/596ad7629c5b3756bc000003/test_file_reports?page%5Bnumber%5D=2&page%5Bsize%5D=3").
            to_return(status: 200, body: file_fixture('page2.json'))

        allow(ProjectMetrics).to receive(:metric_names).and_return(%w[code_climate test_coverage])
      end

      it 'creates data correctly' do
        expect { @project.resample_all_metrics }.to change { MetricSample.count }.by(2)
      end

      it 'creates raw_data record' do
        expect { @project.resample_all_metrics }.to change { RawData.count }.by(4)
      end

      it 'reuses data', skip_request_data: true do
        @project.resample_all_metrics
        expect(@req_project).to have_been_made.once
      end
    end
  end

  describe 'resample_metric' do
    before :each do
      @project = create(:project)
      expect(@project).to receive(:build_metric_for).with(:test, 0).and_return(generic_metric)
    end

    it 'creates a metric_sample' do
      expect { @project.resample_metric(:test, 0) }.to change { @project.metric_samples.count }.by(1)
    end

    it 'creates a raw_data' do
      expect { @project.resample_metric(:test, 0) }.to change { @project.raw_data.count }.by(1)
    end
  end

  describe 'compute_issues' do
    before :each do
      @project = create(:project)
      3.times { create(:raw_data, project: @project) }
      create(:iteration, project: @project, start_time: Date.today-3.days, end_time: Date.today+3.days)
    end

    it 'computes all issues' do
      expect(ProjectIssue).to receive(:test_coverage_drop).with(@project, 3, 1)
      expect(ProjectIssue).to receive(:maintainability_drop).with(@project, 3, 1)
      @project.compute_issues
    end
  end

end
