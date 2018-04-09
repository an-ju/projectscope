require 'rails_helper'

describe Task do
  describe 'danger when possibly unable to finish task' do
    skip
  end

  before(:each) do
    @iteration = create(:iteration)
    @github_task = create(:task, :github, iteration_id: @iteration.id)
    @local_task = create(:task, :local, iteration_id: @iteration.id)
    @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
  end

  describe 'create three types of tasks' do

    it {expect(@github_task.iteration_id).to be @iteration.id}
    it {expect(@local_task).not_to be_nil}
    it {expect(@pivotal_task).not_to be_nil}

    it 'contains all task' do
      tasks = Task.where(iteration: @iteration.id)
      expect(tasks).to include(@github_task)
      expect(tasks).to include(@pivotal_task)
      expect(tasks).to include(@local_task)
    end
  end

  describe 'iterate through task and update' do
    before(:each) do
      @tasks = Task.where(iteration: @iteration.id)
    end
    it 'receive event hash and iterate itself' do
      expect(Task.tasks_update_all(@tasks, "customer meeting", "true")).not_to be_nil
    end
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