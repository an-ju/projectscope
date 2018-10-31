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
  Updaters = %w[github pivotal local requesting planning execution delivering].freeze
  UPDATER = {
    github: GithubUpdater,
    pivotal: PivotalUpdater,
    local: LocalUpdater,
    requesting: RequestingUpdater,
    planning: PlanningUpdater,
    execution: ExecutionUpdater,
    delivering: DeliveringUpdater,
    testing: TestingUpdater
  }.stringify_keys.freeze
  Requesting = ['Contact Customer', 'Customer Meeting', 'Create Stories'].freeze
  Planning = ['Planning Meetings', 'Behavior Tests'].freeze
  Execution = ['Unit Tests', 'Implementation'].freeze
  Delivering = ['Pull Requests', 'Code Review'].freeze
  validates :task_status, presence: true, inclusion: { in: Status }
  validates :updater_type, presence: true, inclusion: { in: Updaters | ["testing"]}
  validates :title, inclusion: { in: Requesting | Planning | Execution | Delivering | ["test task"]}

  # Static constant defined by the type of updater
  def self.phases_task
    return Requesting, Planning, Execution, Delivering
  end

  # According to iteration separate all tasks according to their updater type(categories)
  def self.tasks_selection iteration
    tasks = Task.where(iteration: iteration.id)
    requestingTasks = tasks.select{|task| task.updater_type == 'requesting'}
    planningTasks = tasks.select{|task| task.updater_type == 'planning'}
    executionTasks = tasks.select{|task| task.updater_type == 'execution'}
    deliveringTasks = tasks.select{|task| task.updater_type == 'delivering'}
    return requestingTasks, planningTasks, executionTasks, deliveringTasks
  end

  def updatable?
    (task_status == 'started') or (task_status == 'danger')
  end

  def startable?
    task_status == 'unstarted'
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
