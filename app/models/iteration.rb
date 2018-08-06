class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  # calculate the percentage of accomplish of each task graph
  def self.percentage_progress preTasks, devTasks, postTasks
    precount = preTasks.select{ |task| task.task_status == 'finished'}.count*100.0
    devcount = devTasks.select{ |task| task.task_status == 'finished'}.count*100.0
    postcount = postTasks.select{ |task| task.task_status == 'finished'}.count*100.0
    precountdanger = preTasks.select{ |task| task.task_status == 'danger'}.count*100.0
    devcountdanger = devTasks.select{ |task| task.task_status == 'danger'}.count*100.0
    postcountdanger = postTasks.select{ |task| task.task_status == 'danger'}.count*100.0
    perdan = prepercent = devpercent = devdan = postpercent = postdan = 0
    if preTasks.count > 0
      prepercent = precount / preTasks.count
      predan = precountdanger / preTasks.count
    end

    if devTasks.count > 0
      devpercent = devcount / devTasks.count
      devdan = devcountdanger / devTasks.count
    end

    if postTasks.count > 0
      postpercent = postcount / postTasks.count
      postdan = postcountdanger / postTasks.count
    end
    return prepercent, devpercent, postpercent, predan, devdan, postdan
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
    iter = Iteration.find(iteration_id)
    projects.each do |proj|
      Iteration.copy_assignment iter,proj.id
    end
  end

  # copy iteration assignment to the new project
  def self.copy_assignment iteration, projid
    newiter = Iteration.new()
    newiter.project_id = projid
    newiter.template = false
    newiter.name = iteration.name
    newiter.active = true
    newiter.save
    tasks = Task.where(iteration_id: iteration.id)
    tasks.each do |task|
      newt = Task.new
      newt.title = task.title
      newt.updater_type = task.updater_type
      newt.description = task.description
      newt.task_status = 'unstarted'
      newt.iteration_id = newiter.id
      newt.save
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

  # Set the start time and end time
  def set_timestamp start_time, end_time
    start = (start_time.split('/')).map{|s| s.to_i}
    startime = DateTime.new(start[0],start[1],start[2])
    endtime = (end_time.split('/')).map{|s| s.to_i}
    ending = DateTime.new(endtime[0],endtime[1],endtime[2])
    self.update_attribute(:end_time,ending)
    self.update_attribute(:start_time,startime)
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
