require 'rails_helper'

RSpec.describe ProjectIssuesController, type: :controller do
  let(:p) { create(:project) }

  describe 'GET index' do
    before :each do
      3.times { create(:project_issue, project: p) }
    end

    it 'renders index' do
      get :index, params: { project_id: p.id }
      expect(response).to render_template('project_issues/index')
    end

    it 'sets parameters' do
      get :index, params: { project_id: p.id }
      expect(assigns(:project)).to eql(p)
    end
  end

  describe 'GET show' do
    let(:issue) { create(:project_issue, project: p) }

    it 'renders index' do
      get :show, params: { project_id: p.id, id: issue.id }
      expect(response).to render_template('project_issues/show')
    end

    it 'sets parameters' do
      get :show, params: { project_id: p.id, id: issue.id }
      expect(assigns(:project)).to eql(p)
      expect(assigns(:project_issue)).to eql(issue)
    end
  end
end
