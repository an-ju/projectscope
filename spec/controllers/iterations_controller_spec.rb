require 'rails_helper'

RSpec.describe IterationsController, type: :controller do
  before :each do
    @p1 = create(:project)
    @p2 = create(:project)
  end

  describe 'POST iterations' do
    it 'creates iterations for all projects' do
      expect do
        post :create, params: {
            iteration: {
                name: 'Iteration 1',
                apply_to_all: true
            }
        }
      end.to change { Iteration.count }.by(2)
      expect(@p1.iterations.length).to eq(1)
      expect(@p2.iterations.length).to eq(1)
    end

    it 'creates iteration for one project' do
      expect do
        post :create, params: {
            iteration: {
                name: 'Iteration 1',
                project: @p1.id
            }
        }
      end.to change { Iteration.count }.by(1)
      expect(@p1.iterations.length).to eq(1)
      expect(@p2.iterations.length).to eq(0)
    end
  end

end

