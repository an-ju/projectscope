require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature 'New project page', type: :feature do
  scenario 'Display one input field for each parameter' do
    sign_in_admin
    visit new_project_path
    all_parameters.each do |p|
      expect(page.all(:css, "input##{p}").length).to eql(1)
    end
  end
end

RSpec.feature 'Create projects with configurations', type: :feature do
  scenario 'Correct parameters should successfully create a project' do
    prev_count = Project.count
    sign_in_admin
    visit new_project_path
    fill_in 'project[name]', with: 'unique test'
    fill_in 'project[user_id]', with: 1
    click_button 'Create'
    expect(Project.count).to eq(prev_count + 1)
    expect(Project.find_by(name: 'unique test', user_id: 1)).not_to be_nil
  end

  scenario 'Project creation should store configurations properly' do
    prev_count = Config.count
    sign_in_admin
    visit new_project_path
    fill_in 'project[name]', with: 'test'
    fill_in 'project[user_id]', with: 1
    fill_in_parameters
    click_button 'Create'

    expect(Config.count).to be > prev_count
    all_parameters.each do |p|
      expect(Config.find_by(metrics_params: p, token: "test for #{p}")).not_to be_nil
    end
  end
end

def fill_in_parameters
  all_parameters.each do |param|
    fill_in param, with: "test for #{param}"
  end
end

def all_parameters
  ProjectMetrics.metric_names.flat_map { |m| ProjectMetrics.class_for(m).credentials }.uniq
end
