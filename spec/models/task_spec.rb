require 'rails_helper'

describe Task do
  before(:each) do
    @iteration = create(:iteration)
    @github_task = create(:task, :github, iteration_id: @iteration.id)
    @local_task = create(:task, :local, iteration_id: @iteration.id)
    @cm_task = create(:task, :preliminary, iteration_id: @iteration.id, title: 'Customer Meeting')
    @pivotal_task = create(:task, :pivotal, iteration_id: @iteration.id)
    @danger_task = create(:task, :pivotal, iteration_id: @iteration.id, task_status:'danger')
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
    it 'task with status started should be updatable' do
      expect(@local_task.updatable?).to be(true)
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

  describe 'update the task when reach requirement' do
    it 'update the task' do
      task = Task.find(@cm_task.id)
      task.title = 'Iteration Planning'
      task.description = 'testing'
      task.save
      expect(Task.find(@cm_task.id).title).to eq('Iteration Planning')
      expect(Task.find(@cm_task.id).description).to eq('testing')
    end
  end

  describe 'create the task' do
    before(:each) do
      @params = {}
      @params[:updater_type] = "preliminary"
      @params[:title] = 'Iteration Planning'
      @params[:iteration_id] = 1
      @params[:description] = "testing"
      @params[:duration] = 1
    end
    it 'create the task with information passing in' do
      newtask = Task.new
      newtask.updater_type = @params[:updater_type]
      newtask.title = @params[:title]
      newtask.task_status = "unstarted"
      newtask.iteration_id = @params[:iteration_id]
      newtask.description = @params[:description]
      newtask.duration = @params[:duration]
      expect(newtask.save).to be true
    end

    it 'call task and do the job' do
      expect(Task.create_task @params).not_to be_nil
    end

  end
  describe 'update only started' do
    skip
  end

  describe 'danger when possibly unable to finish task' do
    skip
  end

  describe 'return and specify tasks from different categories' do
    before(:each) do
      @iteration = create(:iteration)
      @pre_task = create(:task, :preliminary, iteration_id: @iteration.id, title: 'Customer Meeting')
      @dev_task = create(:task, :development, iteration_id: @iteration.id, title: 'Lo-fi Mockup')
      @post_task = create(:task, :post, iteration_id: @iteration.id, title: 'Deploy')
    end

    it 'return the correct tasks categories' do
      dev, pre, post = Task.phases_task
      @devtaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                        'Finish Story', 'TDD and BDD', 'Points Estimation',
                        'Pull Request'].freeze
      @pretaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                        'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
      @postaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
      expect(dev).to eq @devtaskTitles
      expect(pre).to eq @pretaskTitles
      expect(post).to eq @postaskTitles
    end

    it 'categorize the tasks' do
      devT, preT, postT = Task.tasks_selection @iteration
      expect(devT).to include @pre_task
      expect(preT).to include @dev_task
      expect(postT).to include @post_task
    end
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