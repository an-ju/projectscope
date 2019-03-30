require 'rails_helper'

describe Iteration do
  describe 'abstract task graph' do
    it "should have task graph function" do
      skip
    end
  end

  describe 'iteration tasks percentage calculation' do
    before(:each) do
      @iteration = create(:iteration)
      @retask1 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'finished')
      @retask2 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'started')
      @plantask1 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @plantask2 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @exetask1 = create(:task, :execution, iteration_id: @iteration.id, task_status:'danger')
      @exettask2 = create(:task, :execution, iteration_id: @iteration.id, task_status:'started')
      @detask1 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'danger')
      @detask2 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'started')
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'should show the correct percentage' do
      tasks = Hash.new
      tasks[:requestingTasks] = @tasks.select{|task| task.updater_type == 'requesting'}
      tasks[:planningTasks] = @tasks.select{|task| task.updater_type == 'planning'}
      tasks[:executionTasks] = @tasks.select{|task| task.updater_type == 'execution'}
      tasks[:deliveringTasks] = @tasks.select{|task| task.updater_type == 'delivering'}
      percentage = Iteration.percentage_progress tasks
      expect(percentage[:reqpercent]).to eq 50
      expect(percentage[:planpercent]).to eq 100
      expect(percentage[:exepercent]).to eq 0
    end

  end

  describe 'copy over the iteration' do
    before(:each) do
      @iteration = create(:iteration)
      @retask1 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'finished')
      @retask2 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'started')
      @plantask1 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @plantask2 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @exetask1 = create(:task, :execution, iteration_id: @iteration.id, task_status:'danger')
      @exettask2 = create(:task, :execution, iteration_id: @iteration.id, task_status:'started')
      @detask1 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'danger')
      @detask2 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'started')
      testproj1 =  create(:project)
      testproj2 =  create(:project)
      @tasks = @iteration.tasks
    end

    it 'should copy the iteration' do
      newiter = Iteration.new()
      newiter.save
      expect(newiter).not_to eq nil
    end

    it 'can call the tasks' do
      tasks = @iteration.tasks
      expect(tasks).to include @retask1
    end

    it 'copy one task' do
      newt = Task.new
      newt.title = @retask1.title
      newt.updater_type = @retask1.updater_type
      newt.description = @retask1.description
      newt.task_status = 'unstarted'
      newt.iteration_id = 2
      expect(newt.save).to be true
    end

    it 'should copy over the tasks' do
      newiter = Iteration.new()
      newiter.project_id = 1
      newiter.save
      expect(newiter.save).not_to be_nil
      tasks = @iteration.tasks
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
      expect(Iteration.copy_assignment(@iteration.id,2)).not_to be_nil
    end

    it 'run the copy assignment function successfully' do
      newiter = Iteration.copy_assignment(@iteration.id,2)
      tasks = @iteration.tasks
      tasks.each do |task|
        expect(Task.where(iteration_id: newiter.id).where(title: task.title)).not_to be_nil
        expect(Task.where(iteration_id: newiter.id).where(description: task.description)).not_to be_nil
      end
    end

    it 'copy assignment task status should all be unstarted' do
      newiter = Iteration.copy_assignment(@iteration.id,2)
      tasks = Task.where(iteration_id: newiter.id)
      tasks.each do |task|
        expect(task.task_status).to eq "unstarted"
      end
    end

    it 'run over a copy assignment all the existing projects' do
      expect(Iteration.all_copy_assignment @iteration.id).not_to be_nil
    end

    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration.id
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        expect(iter).not_to be_nil
      end
    end

    it 'after assigning the new iteration to a tasks,they should all be active' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration.id
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        expect(iter[0].active).to eq true
      end
    end

    it 'should only have at most one active iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration.id
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id).where(active: true)
        expect(iter.length <= 1).to eq true
      end
    end

    it 'run over a copy assignment all the existing projects with creating new iteration' do
      projs = Project.all
      Iteration.all_copy_assignment @iteration.id
      projs.each do |proj|
        iter = Iteration.where(project_id: proj.id)
        @tasks.each do |task|
          expect(Task.where(iteration_id: iter[0].id).where(title: task.title)).not_to be_nil
        end
        expect(iter).not_to be_nil
      end
    end
  end

  describe 'present the progress of the assignment' do
    before(:each) do
      @testproj3 = create(:project)
      @iteration = create(:iteration, active: true, project_id: @testproj3.id)
      @retask1 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'finished')
      @retask2 = create(:task, :requesting, iteration_id: @iteration.id, task_status:'started')
      @plantask1 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @plantask2 = create(:task, :planning, iteration_id: @iteration.id, task_status:'finished')
      @exetask1 = create(:task, :execution, iteration_id: @iteration.id, task_status:'danger')
      @exettask2 = create(:task, :execution, iteration_id: @iteration.id, task_status:'started')
      @detask1 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'danger')
      @detask2 = create(:task, :delivering, iteration_id: @iteration.id, task_status:'started')
      @testproj1 =  create(:project)
      @testproj2 =  create(:project)
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'find out the correct iteration belong to the iteration' do
      iter = Iteration.where(project_id: @testproj3.id).where(active: true).limit(1)
      expect(iter[0]).to eq @iteration
    end

    it 'perform the function and return a list of number of tasks of each status' do
      expect(Iteration.count_graph_status @testproj3.id).to eq [3,2,3,0]
    end

    it 'perform the function and return false when there is no such project to be found' do
      expect(Iteration.count_graph_status @testproj1.id).to eq nil
    end

    it 'count the status of all the projects and return the hash' do
      expect(Iteration.task_progress).not_to be_nil
    end

    it 'count the status of all the projects and return the hash' do
      progress_hash = Iteration.task_progress
      expect(Project.all).to include(@testproj3)
      expect(Project.all).to include(@testproj1)
      expect(Project.all).to include(@testproj2)
      expect(progress_hash[@testproj3.id]).to eq [3,2,3,0]
      expect(progress_hash[@testproj1.id]).to eq nil
      expect(progress_hash[@testproj2.id]).to eq nil
    end

    it 'translate input string to datetime' do
      expect('2022/03/01'.split('/')).to eq ['2022','03','01']
      expect('31'.to_i).to eq 31
      expect(['2022','03','01'].map{|s| s.to_i}).to eq [2022,3,1]
      expect(('2022/03/01'.split('/')).map{|s| s.to_i}).to eq [2022,3,1]
    end

    it 'deal with the time stamp input and output' do
      itera = Iteration.new()
      starttime = DateTime.new([2022,03,01][0],[2022,03,01][1],[2022,03,01][2])
      endtime = DateTime.new(2001,4,3)
      itera.start_time = starttime
      expect(itera.save).to be true
      expect(itera.update_attribute(:end_time,endtime)).to be true
      expect(itera.end_time).to eq DateTime.new(2001,4,3)
    end

    it 'the function is corret' do
      iter = Iteration.new()
      iter.save
      start_time = '2022/03/01'
      end_time = '2023/03/01'
      iter = Iteration.find(iter.id)
      expect(iter.set_timestamp start_time, end_time).not_to be_nil
      expect(iter.start_time).to eq DateTime.new(2022,3,1)
      expect(iter.end_time).to eq DateTime.new(2023,3,1)
    end

    it 'get the current time' do
      b = Time.new(2012, 9, 29, 0, 0, 0.5)
      expect(DateTime.now).not_to be_nil
    end

    it 'return the current running iteration' do
      a = Time.new(2012, 8, 29, 0, 0, 0.5)
      b = Time.new(2012, 9, 29, 0, 0, 0.5)
      expect(b > a).to eq true
    end

    it 'return the current running iteration' do
      iter = Iteration.new()
      iter.save
      start_time = '2022/03/01'
      end_time = '2023/03/01'
      iter = Iteration.find(iter.id)
      iter.set_timestamp start_time, end_time
      a = Time.new(2022, 8, 29, 0, 0, 0.5)
      expect(iter.current_iter?(a)).to eq true
    end

    it 'return the actual current iteration' do
      iter = Iteration.new()
      iter.save
      start_time = '2014/03/01'
      end_time = '2023/03/01'
      iter.project_id = @testproj3.id
      iter.set_timestamp start_time, end_time
      iter1 = Iteration.new()
      iter1.project_id = @testproj3.id
      iter1.save
      start_time1 = '2022/03/01'
      end_time1 = '2023/03/01'
      iter1.set_timestamp start_time1, end_time1
      a = Time.new(2022, 8, 29, 0, 0, 0.5)
      expect(Iteration.current_iter @testproj3).to eq iter
    end

    it 'return the actual current iteration' do
      iter = Iteration.new()
      iter.save
      start_time = '2014/03/01'
      end_time = '2015/03/01'
      iter.project_id = @testproj1.id
      iter.set_timestamp start_time, end_time
      expect(Iteration.current_iter @testproj3).to eq nil
    end

    it 'return the current time ' do
      expect(Time.now).not_to be_nil
    end

  end

  describe 'Create iteration template and modify the tasks graph' do
    it 'create the iteration' do
      iteration = Iteration.create(name: "template", template: true)
      expect(iteration).not_to be_nil
    end

    it 'create a template iteration to include tasks graph' do
      iter = Iteration.create(name: "template", template: true)
      expect(Iteration.where(template: true)).to include iter
    end
  end

  describe 'Select all tasks of each project' do
    before(:each) do
      @project1 = create(:project)
      @project2 = create(:project)
      starttime = DateTime.new(2001,3,1)
      endtime = DateTime.new(2022,4,3)
      @iter1 = create(:iteration, start_time: starttime, end_time:endtime, project_id: @project1.id)
      @iter2 = create(:iteration, start_time: starttime, end_time:endtime, project_id: @project2.id)
      @retask1 = create(:task, :requesting, iteration_id: @iter1.id, task_status:'finished')
      @retask2 = create(:task, :requesting, iteration_id: @iter2.id, task_status:'started')
      @plantask1 = create(:task, :planning, iteration_id: @iter1.id, task_status:'finished')
      @plantask2 = create(:task, :planning, iteration_id: @iter2.id, task_status:'finished')
    end

    it 'current task be correctly shown' do
      tasks_iter = Iteration.collect_current_tasks
      expect(Project.all).to include @project1
      iter = Iteration.current_iter @project1
      expect(iter).to eq @iter1
      expect(tasks_iter[@project1.id]).to include @retask1
      expect(tasks_iter[@project2.id]).to include @retask2
      expect(tasks_iter[@project2.id]).to include @plantask2
      expect(tasks_iter[@project1.id]).to include @plantask1
    end
  end

end