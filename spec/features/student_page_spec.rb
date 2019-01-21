require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature "Student Pages", type: :feature do
  background do
    @p = create(:project)
  end

  scenario 'shows a project' do
    sign_in_admin
    visit project_path(@p)
    expect(page).to have_css 'a', text: 'Config'
    expect(page).to have_content @p.name
  end

end
