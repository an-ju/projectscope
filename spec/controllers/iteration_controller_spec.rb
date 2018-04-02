require 'rails_helper'

RSpec.describe IterationsController, type: :controller do

  describe 'show task graph' do
    before(:each) do
      @iteration = create(:iteration)
      @github_task = create(:task, :github, iteration_id: @iteration.id)
      @local_task = create(:task, :local, iteration_id: @iteration.id)
      @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    end

    it "should get the all tasks iteration have" do
      expect(Task.where(iteration_id: @iteration.id)).to include @github_task
      expect(Task.where(iteration_id: @iteration.id)).to include @local_task
      expect(Task.where(iteration_id: @iteration.id)).to include @pivotal_task
    end
  end

  describe 'event call back' do
    skip
  end

  describe 'update all'do
    before(:each) do
      @iteration = create(:iteration)
      @github_task = create(:task, :github, iteration_id: @iteration.id)
      @local_task = create(:task, :local, iteration_id: @iteration.id)
      @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    end

    it "identify all task that are not finished" do
      skip
    end

    it "send access_token and time_stamp to event" do
      skip
    end

    it "iterate through all the unfinished task and parse them with return new events" do
      skip
    end

    it "send task to update if they are parsed in" do
      skip
    end

    it "update task if they reach requirement" do
      skip
    end


  end

  describe 'task reset' do
    before(:each) do
      @iteration = create(:iteration)
    end
    skip
  end




end
