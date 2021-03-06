require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature "Student Pages", type: :feature do
  background do
    @p = create(:project)
    @iter = create(:iteration, project: @p, start_time: Date.today - 3.days, end_time: Date.today + 3.days)
  end

  scenario 'shows a project' do
    sign_in_admin
    visit project_path(@p)
    expect(page).to have_content'Config'
    expect(page).to have_content @p.name
  end

  scenario 'shows the iteration name' do
    sign_in_admin
    visit project_path(@p)
    expect(page).to have_content @iter.name
  end
end
