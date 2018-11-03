require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')
require Rails.root.join('spec', 'support', 'projects_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature "MetricDashboards", js:false, type: :feature do
  before :each do
    seed_metric_samples
  end

  scenario 'display all projects and metrics' do
    sign_in_admin
    visit projects_path
    Project.all.each do |p|
      expect(page).to have_link(p.name, href: project_path(p))
    end
  end

  scenario 'store image data in the element' do
    sign_in_admin
    visit projects_path
    metrics = ProjectMetrics.hierarchies(:metric).first
    check_metrics(metrics, Date.today)
  end

  scenario 'page and time selection' do
    sign_in_admin
    visit projects_path(page: 2, days_from_now: 1)
    metrics = ProjectMetrics.hierarchies(:metric).second
    check_metrics(metrics, Date.today - 1)
  end

  scenario 'navigate through pages' do
    sign_in_admin
    visit projects_path
    visit projects_path(days_from_now: 1)
    metrics = ProjectMetrics.hierarchies(:metric).first
    check_metrics(metrics, Date.today - 1)
  end
end

def d_values(page)
  page.all('metric-table-project-metric').map { |elem| elem[:d] }.join('')
end

def check_metrics(metrics, date)
  Project.all.each do |p|
    metrics.each do |m|
      expect(d_values(page)).to include(image_metric_for(p, date, m))
      expect(d_values(page)).not_to include(raw_data_for(p, date, m))
    end
  end
end

