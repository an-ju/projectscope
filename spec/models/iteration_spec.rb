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

  describe 'copy over the iteration' do
    before(:each) do
      @iteration = create(:iteration)
      @pretask1 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'finished')
      @pretask2 = create(:task, :preliminary, iteration_id: @iteration.id, task_status:'started')
      @devtask1 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @devtask2 = create(:task, :development, iteration_id: @iteration.id, task_status:'finished')
      @posttask1 = create(:task, :post, iteration_id: @iteration.id, task_status:'danger')
      @posttask2 = create(:task, :post, iteration_id: @iteration.id, task_status:'started')
      testproj1 =  create(:project)
      testproj2 =  create(:project)
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'should copy the iteration' do
      newiter = Iteration.new()
      newiter.save
      expect(newiter).not_to eq nil
    end

    it 'can call the tasks' do
      tasks = Task.where(Iteration_id = @iteration.id)
      expect(tasks).to include @pretask1
    end

    it 'copy one task' do
      newt = Task.new
      newt.title = @pretask1.title
      newt.updater_type = @pretask1.updater_type
      newt.description = @pretask1.description
      newt.task_status = 'unstarted'
      newt.iteration_id = 2
      expect(newt.save).to be true
    end

    it 'should copy over the tasks' do
      newiter = Iteration.new()
      newiter.project_id = 1
      newiter.save
      expect(newiter.save).not_to be_nil
      tasks = Task.where(Iteration_id = @iteration.id)
      tasks.each do |task|
        newt = Task.new
        newt.title = task.title
        newt.updater_type = task.updater_type
        newt.description = task.description
        newt.task_status = 'unstarted'
        newt.iteration_id = newiter
        newt.save
        expect(newt.save).to be true
      end
      tasks.each do |task|
        expect(Task.where(iteration_id: newiter.id).where(title: task.title)).not_to be_nil
      end
    end

    it 'run the copy assignment function' do
      expect(Iteration.copy_assignment(@iteration,2)).not_to be_nil
    end

    it 'run the copy assignment function successfully' do
      newiter = Iteration.copy_assignment(@iteration,2)
      tasks = Task.where(Iteration_id = @iteration.id)
      tasks.each do |task|
        expect(Task.where(iteration_id: newiter.id).where(title: task.title)).not_to be_nil
      end
    end

    it 'run over a copy assignment all the existing projects' do
      expect(Iteration.all_copy_assignment @iteration).not_to be_nil
    end

    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        expect(iter).not_to be_nil
      end
    end
    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        @tasks.each do |task|
          expect(Task.where(iteration_id: iter[0].id).where(title: task.title)).not_to be_nil
        end
        expect(iter).not_to be_nil
      end
    end


  end

  describe 'iteration copying' do
    before(:each) do

    end
  end

  describe '' do

  end
end