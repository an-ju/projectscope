require 'rails_helper'
require Rails.root.join('spec', 'support', 'sign_in_helpers')
require Rails.root.join('spec', 'support', 'projects_helpers')

RSpec.configure do |c|
  c.include Features
end

RSpec.feature "Project edit page", type: :feature do
  before :each do
    @project = set_up_project_with_configs
  end

  scenario 'Display one parameter input per metric' do
    sign_in_admin
    visit edit_project_path @project
    metric_params do |metric, param|
      expect(page.find("#{metric}-#{param}")).to eql(1)
    end
  end

  scenario 'Remember the old parameter for inputs other than token' do
    sign_in_admin
    visit edit_project_path @project
    metric_params do |metric, param|
      if param.contains? 'token'
        expect(page.find(fake_config(metric, param))).to eql(0)
      else
        expect(page.find(fake_config(metric, param))).to eql(1)
      end
    end
  end
end


RSpec.feature 'Edit project configurations', type: :feature do
  before :each do
    @project = set_up_project_with_configs
  end

  scenario 'Update project parameters' do
    sign_in_admin
    visit edit_project_path @project
    metric_params do |metric, param|
      fill_in "#{metric}-#{param}", with: "#{param} for #{metric} edited"
    end
    click_button 'Finish'
    metric_params do |metric, param|
      config = @project.configs.where(metric_name: metric, metrics_params: param).take
      expect(config.token).to eq("#{param} for #{metric} edited")
    end
  end
end


