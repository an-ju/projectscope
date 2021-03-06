class Iteration < ApplicationRecord
  belongs_to :project
  has_many :tasks

  def final_project_issues
    max_version = project.project_issues.where('created_at > ? AND created_at < ?', start_time, end_time).maximum(:data_version)
    project.project_issues.where("data_version = ?", max_version)
  end

  # calculate the percentage of accomplish of each task graph
  def self.percentage_progress multitasks
    percentage = Hash.new
    percentage[:reqpercent], percentage[:reqdan] = Iteration.calculate_type multitasks[:requestingTasks]
    percentage[:planpercent],percentage[:plandan] = Iteration.calculate_type multitasks[:planningTasks]
    percentage[:exepercent],percentage[:execdan] = Iteration.calculate_type multitasks[:executionTasks]
    percentage[:deliverpercent],percentage[:deliverdan] = Iteration.calculate_type multitasks[:deliveringTasks]
    return percentage
  end

  # calculate each type
  def self.calculate_type tasks
    danpercent = finishpercent = 0
    if tasks.count > 0
      finishpercent = tasks.select{ |task| task.task_status == 'finished'}.count * 100.0 / tasks.count
      danpercent = tasks.select{ |task| task.task_status == 'danger'}.count * 100.0 / tasks.count
    end
    return finishpercent, danpercent
  end

  # return the 2-d lists where the key is stored inside the level slot
  def self.level_up graphlevel, graph
    rank = Array.new
    pos = Hash.new
    graphlevel.each do |key, value|
      if rank[value].nil?
        rank[value] = Array.new
      end
      rank[value].append key
      if (graph[key].length) > 0
        rank[value].concat([nil] * ((graph[key].length) - 1))
      end
      pos[key] = rank[value].length
    end
    rank
  end

  # assign the iteration template to each project
  def self.all_copy_assignment iteration_id
    projects = Project.all
    projects.each do |proj|
      Iteration.copy_assignment iteration_id,proj.id
    end
  end

  # copy iteration assignment to the new project
  def self.copy_assignment iteration_id, projid
    newiter = Iteration.create(project_id: projid, template: false, active: true)
    tasks = Task.where(iteration_id: iteration_id)
    tasks.each do |task|
      newt = Task.create(title: task.title, updater_type: task.updater_type, description: task.description,
        task_status: "unstarted", iteration_id: newiter.id,duration: task.duration)
    end
    newiter
  end

  # Count the number of each status
  def self.count_graph_status project_id
    iter = Iteration.where(project_id: project_id).where(active: true).limit(1)
    false
    if(iter.length > 0)
      tasks = Task.where(iteration_id: iter[0].id)
      finished = tasks.select{|t| t.task_status == "finished"}.count
      danger = tasks.select{|t| t.task_status == "danger"}.count
      started = tasks.select{|t| t.task_status == "started"}.count
      unstarted = tasks.select{|t| t.task_status == "unstarted"}.count
      return finished, danger, started, unstarted
    end
  end

  # Set the start time and end time like yyyy/mm/dd
  def set_timestamp start_time, end_time
    start = (start_time.split('/')).map{|s| s.to_i}
    endtime = (end_time.split('/')).map{|s| s.to_i}
    startime = DateTime.new(start[0],start[1],start[2])
    ending = DateTime.new(endtime[0],endtime[1],endtime[2])
    self.update_attributes(end_time: ending, start_time: startime)
  end

  # Count the status of all the projects and return the hash
  def self.task_progress
    projects = Project.all
    progress_hash = {}
    projects.each do |proj|
      progress_hash[proj.id] = Iteration.count_graph_status proj.id
    end
    progress_hash
  end

  # Tasks for each project's current iteration
  def self.collect_current_tasks
    tasks_iter = {}
    Project.all.each do |proj|
      iter = Iteration.current_iter proj
      tasks_iter[proj.id] = []
      if iter != nil
        tasks = Task.where(iteration_id: iter.id)
        tasks_iter[proj.id] = tasks
      end
    end
    tasks_iter
  end

  # return true if the time stamp is inside the time
  def current_iter? time
    self.start_time < time and self.end_time > time
  end

  # return the current processing iteration for project
  def self.current_iter proj
    iters = Iteration.where(project_id: proj.id).where("start_time<?",Time.now).where("end_time>?",Time.now)
    iters.each do |iter|
      return iter
    end
    nil
  end

  # Find out the height and length of the graph
  def self.max_level_elem ranklist
    ranklist.map{ |list| list.length }.max
  end

  # Update all task
  def update_task_graph event_update_hash
    tasks = Task.where(iteration_id: self.id)
    event_update_hash.each do |key, value|
      Task.tasks_update_all tasks, key,value
    end
    true
  end
end
