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

  context 'pivotal tracker' do
    before :each do
      @p = create(:project)
      @m1 = create( :project_metric_point_distribution,
                    project: @p,
                    image: { data: { planned: [nil, nil, nil],
                                     started: [nil, nil],
                                     finished: [nil],
                                     delivered: [{ id: 1, owner_ids: [1, 2] }] }})
      @m2 = create( :project_metric_point_distribution,
                    project: @p,
                    image: { data: { delivered: [{ id: 1, owner_ids: [1, 2]},
                                                 { id: 2, owner_ids: [1] }]}})
      create(:tracker_memberships,
             project: @p,
             data_version: @m2.data_version,
             content: [ { id: 1, person: { name: 'test A' } },
                        { id: 2, person: { name: 'test B' } } ])
    end

    describe 'unfinished_backlog' do
      it 'detects the issue' do
        expect(described_class).to receive(:create).exactly(3).times
        described_class.unfinished_backlog(@p, @m1.data_version, nil)
      end
    end

    describe 'no_slacking_tracker' do
      it 'detects the issue' do
        expect(described_class).to receive(:create).once
        described_class.no_slacking_tracker(@p, @m2.data_version, @m1.data_version)
      end
    end
  end

  context 'tracker activities' do
    before :each do
      @p = create(:project)
      @m1 = create( :project_metric_tracker_activities,
                    project: @p,
                    image: { data: { activities: [
                        { changes: [{ new_values: { before_id: 1, after_id: 3 }}]},
                        { changes: [{ new_values: { before_id: 3 }}]},
                        { changes: [{ new_values: { after_id: 2 }}]}
                    ]}})
      @m2 = create( :project_metric_tracker_activities,
                    project: @p,
                    image: { data: { activities: [
                        { changes: [{ new_values: { }}]}
                    ]}})
    end

    describe 'backlog_change_activities' do
      it 'detects the issue' do
        expect(described_class).to receive(:create)
        described_class.backlog_change_activities(@p, @m1.data_version, nil)
      end

      it 'does not make false positive' do
        expect(described_class).not_to receive(:create)
        described_class.backlog_change_activities(@p, @m2.data_version, nil)
      end
    end
  end

  context 'github branches' do
    before :each do
      @p = create(:project)
      @m1 = create( :github_branches, project: @p,
                    content: [{name: 'b1', commit: {sha: 'sha1'}},
                              {name: '1b2', commit: {sha: 'sha2'}}])
      @m2 = create( :github_branches, project: @p,
                    content: [{name: 'b1', commit: {sha: 'sha1'}},
                              {name: '2b3', commit: {sha: 'sha3'}}])
      @m3 = create( :github_branches, project: @p,
                    content: [{name: '4b4', commit: {sha: 'sha4'}}])
      create( :tracker_stories, project: @p, data_version: @m3.data_version,
              content: [{id: 1}, {id: 2}, {id: 3}])
    end

    describe 'branch_name' do
      it 'detects the issue' do
        expect(described_class).to receive(:create).exactly(2).times
        described_class.branch_name(@p, @m3.data_version, @m1.data_version)
      end
    end
  end

  context 'cycle time' do
    before :each do
      @p = create(:project)
      @m1 = create( :project_metric_cycle_time, project: @p,
                    image: { data: { delivered_stories:[
                        {id: 1}, {id: 2}
                    ]}})
      @m2 = create( :project_metric_cycle_time, project: @p,
                    image: { data: { delivered_stories: [
                        {id: 1},
                        {id: 2},
                        {id: 3, name: 's3',
                         cycle_time_details: { total_cycle_time: 5 * 1000 * 3600,
                                               delivered_time: 0 }},
                        {id: 4, name: 's4',
                         cycle_time_details: { total_cycle_time: 1000 * 10,
                                               delivered_time: 1 }},
                        {id: 5, name: 's5',
                         cycle_time_details: { total_cycle_time: 10 * 24 * 3600 * 1000,
                                               delivered_time: 0 }}
                    ]}})
    end

    describe 'story_cycle_time' do
      it 'detects the issue' do
        expect(described_class).to receive(:create).with(hash_including(name: 'short_cycle_time')).once
        expect(described_class).to receive(:create).with(hash_including(name: 'long_cycle_time')).once
        described_class.story_cycle_time(@p, @m2.data_version, @m1.data_version)
      end
    end
  end
end
