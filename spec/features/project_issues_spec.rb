require 'rails_helper'
require 'support/sign_in_helpers'

RSpec.configure do |config|
  config.include Features
end

RSpec.feature 'Show project issues', type: :feature do
  let(:p) { create(:project) }
  background do
    create(:project_issue, project: p, content: 'This is test 1.')
    create(:project_issue, project: p, content: 'This is test 2.')
    sign_in_admin
  end

  scenario 'index page should list all project issues' do
    visit project_project_issues_path(project_id: p.id)
    expect(page).to have_content('This is test 1.')
    expect(page).to have_content('This is test 2.')
  end
end
