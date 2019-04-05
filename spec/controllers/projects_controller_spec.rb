require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  login_admin
  let(:p) { create(:project) }

  describe 'PUT config' do
    let(:config) { create(:config_github_project, project: p, metric_name: 'github_flow') }
    let(:valid_update_params) { { id: p.id,
                                  config: { metric_name: 'github_flow',
                                      config_name: 'github_project',
                                      config_value: 'test' } } }

    it 'updates the config value' do
      expect { put :update_config, params: valid_update_params }.to change { Config.find(config.id).token }
    end

  end
end