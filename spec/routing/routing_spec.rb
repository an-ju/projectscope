require 'rails_helper'

describe 'Routing', type: :routing do

  describe 'ProjectIssuesController' do
    it 'should route index to project_issues#index' do
      expect(get: '/projects/1/project_issues').to route_to(controller: 'project_issues', action: 'index',
                                                            project_id: '1')
    end

    it 'should route show to project_issues#show' do
      expect(get: '/projects/1/project_issues/2').to route_to(controller: 'project_issues', action: 'show',
                                                              project_id: '1', id: '2')
    end
  end
end