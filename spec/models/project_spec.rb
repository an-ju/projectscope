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
	describe 'when ordered by metrics' do
		before(:each) do
			@p1 = create(:project_with_many_metric_samples)
			@p2 = create(:project_with_many_metric_samples)
		end

		it 'should be sorted by project name' do
			projects = Project.order_by_name("ASC")
			expect(projects[0].id).to eq @p1.id
		end

		it 'should be sorted by metrics' do
			projects = Project.order_by_metric_score "test_metric", "ASC"
			expect(projects[0].id).to eq @p1.id
		end

		it 'should not have duplicate entries' do
			projects = Project.order_by_metric_score "test_metric", "ASC"
			expect(projects.length).to eq 2
		end
  end

  describe 'resample_metric' do
    before :each do
      @project = create(:project)
      expect(@project).to receive(:build_metric_for).with(:test).and_return(generic_metric)
    end

    it 'creates a metric_sample' do
      expect { @project.resample_metric(:test) }.to change { @project.metric_samples.count }.by(1)
    end

    it 'creates a raw_data' do
      expect { @project.resample_metric(:test) }.to change { @project.raw_data.count }.by(1)
    end

  end
end
