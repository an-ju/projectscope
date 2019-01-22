require 'rails_helper'
require 'support/sign_in_helpers'

RSpec.configure do |config|
  config.include Features
end

RSpec.feature "NewIterations", type: :feature do
  background do
    @p1 = create(:project)
    @p2 = create(:project)
  end

  scenario 'apply settings to all' do
    sign_in_admin

    visit new_iteration_path
    fill_in 'name', with: 'Iteration 1'
    check 'apply_to_all'

    click_button 'Submit'

    expect(page).to have_content('Iteration 1')
    expect(Iteration.count).to eql(2)
  end

  scenario 'apply settings to one project' do
    sign_in_admin

    visit new_iteration_path
    fill_in 'name', with: 'Iteration 1'
    uncheck 'apply_to_all'
    select @p1.name, from: 'project'

    click_button 'Submit'
    expect(page).to have_content('Iteration 1')
    expect(Iteration.count).to eql(1)
  end
end
