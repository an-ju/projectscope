require 'rails_helper'
require 'support/sign_in_helpers'

RSpec.configure do |config|
  config.include Features
end

RSpec.feature 'Read real metrics', type: :feature do

  let(:p) { create(:project) }
  background do
    config_params = JSON.parse(file_fixture('tokens.json').read)
    ProjectMetrics.metric_names.each do |m|
      ProjectMetrics.class_for(m).credentials.each do |param|
        if config_params.key? param.to_s
          p.configs << Config.new(metric_name: m, metrics_params: param, token: config_params[param.to_s])
        end
      end
    end
    p.save
    WebMock.allow_net_connect!
  end

  scenario 'resample all metrics' do
    expect { p.resample_all_metrics }.to change { MetricSample.count }
  end

  scenario 'resample pull_requests' do
    metric = p.build_metric_for('pull_requests', p.next_version_number)
    expect(metric.image).to be_a(Hash)
    expect(metric.score).not_to be_nil
  end

  scenario 'resample cycle_time' do
    metric = p.build_metric_for('cycle_time', p.next_version_number)
    expect(metric.image).to be_a(Hash)
    expect(metric.score).not_to be_nil
  end
end

