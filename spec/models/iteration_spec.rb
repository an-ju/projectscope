require 'rails_helper'

describe Iteration do
  describe 'abstract task graph' do
    it "should have task graph function" do
      skip
    end
  end

  describe 'hand over event call back' do
    skip
  end

  describe 'iteration tasks percentage calculation' do
    before(:each) do
      @iteration = create(:iteration)
      @pretask1 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'finished')
      @pretask2 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'started')
      @devtask1 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @devtask2 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @posttask1 = create(:task, :post, iteration_id: @iteration.id, task_status:'danger')
      @posttask2 = create(:task, :post, iteration_id: @iteration.id, task_status:'started')
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'should show the correct percentage' do
      @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
      @devTasks = @tasks.select{|task| task.updater_type == 'development'}
      @postTasks = @tasks.select{|task| task.updater_type == 'post'}
      expect(@preliminaryTasks).not_to be_nil
      expect(@devTasks).not_to be_nil
      expect(@postTasks).not_to be_nil
      expect(@preliminaryTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@devTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@postTasks.select{|t| t.task_status == 'finished'}).not_to be_nil
      expect(@preliminaryTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 1
      expect(@devTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 2
      expect(@postTasks.select{|t| t.task_status == 'finished'}.count*1.0).to eq 0

      precount = @preliminaryTasks.select{|t| t.task_status == 'finished'}.count*1.0
      devcount = @devTasks.select{|t| t.task_status == 'finished'}.count*1.0
      postcount = @postTasks.select{|t| t.task_status == 'finished'}.count*1.0
      @prepercent, @devpercent, @postpercent = Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
      expect(@prepercent).to eq 50
      expect(@devpercent).to eq 100
      expect(@postpercent).to eq 0
    end

  end

  describe 'user must be not nil' do

  end

  describe '' do

  end
end