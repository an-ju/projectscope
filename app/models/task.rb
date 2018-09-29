require 'json'
class Task < ActiveRecord::Base
  belongs_to :iteration

  scope :require_updating, -> { where("status = 'started'") }
  include Updater

  Status = %w[unstarted started finished danger].freeze
  StatusLink = {
    unstarted: :started,
    started: :finished,
    danger: :finished
  }.stringify_keys.freeze
  Updaters = %w[github pivotal local preliminary development post].freeze
  UPDATER = {
    github: GithubUpdater,
    pivotal: PivotalUpdater,
    local: LocalUpdater,
    preliminary: PreliminaryUpdater,
    development: DevelopmentUpdater,
    post: PostUpdater
  }.stringify_keys.freeze
  DevTaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                   'Finish Story', 'TDD and BDD', 'Points Estimation',
                   'Pull Request'].freeze
  PreTaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                   'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
  PostTaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
  validates :task_status, presence: true, inclusion: { in: Status }
  validates :updater_type, presence: true, inclusion: { in: Updaters }
  validates :title, inclusion: { in: PreTaskTitles | DevTaskTitles | PostTaskTitles }

  # Static constant defined by the type of updater
  def self.phases_task
    return DevTaskTitles, PreTaskTitles, PostTaskTitles
  end

  # According to iteration separate all tasks according to their updater type(categories)
  def self.tasks_selection iteration
    tasks = Task.where(iteration: iteration.id)
    preliminaryTasks = tasks.select{|task| task.updater_type == 'preliminary'}
    devTasks = tasks.select{|task| task.updater_type == 'development'}
    postTasks = tasks.select{|task| task.updater_type == 'post'}
    return preliminaryTasks, devTasks, postTasks
  end

  def updatable?
    (task_status == 'started') or (task_status == 'danger')
  end

  def startable?
    task_status == 'unstarted'
  end

  # create a task in iteration or template through params
  def self.create_task params
    newtask = Task.new
    newtask.updater_type = params[:updater_type]
    newtask.title = params[:title]
    newtask.task_status = "unstarted"
    newtask.iteration_id = params[:iteration_id]
    newtask.description = params[:description]
    newtask.duration = params[:duration]
    newtask.save
  end

  # Update the status through Updater
  def update_status(event_name, event_function)
    return self unless updatable?
    UPDATER[updater_type].update self, event_name, event_function
    self
  end

  # iterate through
  def self.tasks_update_all(tasks, event_name, event_value)
    tasks.each do |task|
      task.update_status event_name, event_value
    end
  end

  # updater through updater after analysis
  def callback_updater(key, value)
    if UPDATER[updater_type].analysis_call_back ({key => value})
      update_attributes(task_status: next_status)
    end
  end

  # manually start the task
  def start_task
    false
    if startable?
      next_status = StatusLink[task_status]
      update_attributes(task_status: next_status)
    end
  end

  # manully reset status
  def reset_status
    update_attributes(task_status: 'unstarted')
  end
end
