require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature 'Create projects with configurations', type: :feature do
  scenario 'Correct parameters should successfully create a project' do
    sign_in_admin
    visit new_project_path
    fill_in 'project[name]', with: 'test'
    fill_in 'project[user_id]', with: 1
    click_button 'Create'
    expect(Project.all.length).to eq(1)
  end
end

