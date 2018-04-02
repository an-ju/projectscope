require 'rails_helper'

describe Task do
  describe 'danger when possibly unable to finish task' do
    skip
  end

  describe 'create three types of tasks' do
    before(:each) do
      @iteration = create(:iteration)
      @github_task = create(:task, :github, iteration_id: @iteration.id)
      @local_task = create(:task, :local, iteration_id: @iteration.id)
      @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    end

    it {expect(@github_task.iteration_id).to be @iteration.id}
    it {expect(@local_task).not_to be_nil}
    it {expect(@pivotal_task).not_to be_nil}
  end

  describe 'update only started' do
    skip
  end

  describe 'start task when only if parent task finished' do
    skip
  end

  describe 'github update' do
    skip
  end

  describe 'pivotal update' do
    skip
  end

  describe 'local update' do
    skip
  end
end