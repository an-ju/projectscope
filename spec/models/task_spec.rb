require 'rails_helper'

describe Task do
  before(:each) do
    @iteration = create(:iteration)
    @cm_task = create(:task, :requesting, iteration_id: @iteration.id, title: 'Customer Meeting')
    @danger_task = create(:task, :requesting, iteration_id: @iteration.id, task_status:'danger')
  end

  describe 'iterate through task and update' do
    before(:each) do
      @tasks = Task.where(iteration: @iteration.id)
    end

    it 'task with status danger should be able to udpate' do
      expect(@danger_task.task_status).to eq('danger')
      expect(@danger_task.updatable?).to be (true)
    end

    it 'receive event hash and iterate itself' do
      expect(Task.tasks_update_all(@tasks, "customer meeting", "true")).not_to be_nil
    end

    it 'the iterate function is going to update the key and value of certain task' do
      Task.tasks_update_all(@tasks, "Customer Meeting", "true")
      task = Task.find_by_title("Customer Meeting")
      expect(task.task_status).to eq('finished')
    end

    it 'update each task' do
      expect(@cm_task.update_status("Customer Meeting","true")).not_to be_nil
    end

    it 'successfully update the task' do
      @cm_task.update_status("Customer Meeting","true")
      task = Task.find_by_title('Customer Meeting')
      expect(task.task_status).to eq('finished')
    end
  end

  describe 'create the task' do
    before(:each) do
      @params = {}
      @params[:updater_type] = "requesting"
      @params[:title] = 'Customer Meeting'
      @params[:iteration_id] = 1
      @params[:description] = "testing"
      @params[:duration] = 1
    end

    it 'call task and do the job' do
      expect(Task.create_task @params).not_to be_nil
    end

  end

  describe 'return and specify tasks from different categories' do
    before(:each) do
      @iteration = create(:iteration)
      @pre_task = create(:task, :requesting, iteration_id: @iteration.id, title: 'Customer Meeting')
      @dev_task = create(:task, :planning, iteration_id: @iteration.id, title: 'Planning Meetings')
      @post_task = create(:task, :execution, iteration_id: @iteration.id, title: 'Implementation')
    end

    it 'return the correct tasks categories' do
      req, plan, exe, deliver = Task.phases_task
      @requesting = ['Contact Customer', 'Customer Meeting', 'Create Stories'].freeze
      @planning = ['Planning Meetings', 'Behavior Tests'].freeze
      @execution = ['Unit Tests', 'Implementation'].freeze
      @delivering = ['Pull Requests', 'Code Review'].freeze
      expect(req).to eq @requesting
      expect(plan).to eq @planning
      expect(exe).to eq @execution
      expect(deliver).to eq @delivering
    end

    it 'categorize the tasks' do
      devT, preT, postT = Task.tasks_selection @iteration
      expect(devT).to include @pre_task
      expect(preT).to include @dev_task
      expect(postT).to include @post_task
    end
  end

end