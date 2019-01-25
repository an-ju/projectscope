require 'rails_helper'

RSpec.describe ProjectIssue, type: :model do
  context 'codecimate_report' do
    before :each do
      @project = create(:project)
      @m1 = create(:codeclimate_report, project: @project)
      @m2 = create(:codeclimate_report, project: @project)
    end

    describe 'test_coverage_drop' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.test_coverage_drop(@project, @m2.data_version, @m1.data_version)
      end
    end

    describe 'low_test_coverage' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.low_test_coverage(@project, @m2.data_version, @m1.data_version)
      end
    end
  end

  context 'codeclimate_snapshot' do
    before :each do
      @project = create(:project)
      @m1 = create(:codeclimate_snapshot, project: @project)
      @m2 = create(:codeclimate_snapshot, project: @project)
    end

    describe 'maintainability_drop' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.maintainability_drop(@project, @m2.data_version, @m1.data_version)
      end
    end
  end

  context 'travis ci' do
    before :each do
      @p = create(:project)
      @m1 = create(:project_metric_travis_ci,
                   project: @p,
                   image: {data: { builds: [{ state: 'pass' }]}})
      @m2 = create(:project_metric_travis_ci,
                   project: @p,
                   image: {data: {builds: [{state: 'failed'}]}})
    end

    describe 'breaking_travis' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.breaking_travis(@p, @m2.data_version, @m1.data_version)
      end
    end
  end

  context 'heroku' do
    before :each do
      @p = create(:project)
      create(:iteration, project: @p, start_time: Date.today - 3.days, end_time: Date.today + 3.days)
      @m1 = create( :project_metric_heroku_status,
                    project: @p,
                    image: { data: { release: [{ created_at: '2012-01-01T12:00:00Z',
                                                 status: 'succeeded' }],
                                     web_status: 200 }})
      @m2 = create( :project_metric_heroku_status,
                    project: @p,
                    image: { data: { release: [{ created_at: Time.now.iso8601,
                                                 status: 'failed'}],
                                     web_status: 404 }})

    end

    describe 'no_new_deployment' do
      it 'tracks failed heroku release' do
        expect(described_class).to receive(:create)
        described_class.no_new_deployment(@p, @m2.data_version, nil)
      end

      it 'tracks outdated heroku release' do
        expect(described_class).to receive(:create)
        described_class.no_new_deployment(@p, @m1.data_version, nil)
      end
    end

    describe 'heroku_not_accessible' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.heroku_not_accessible(@p, @m2.data_version, nil)
      end
    end

  end
end
