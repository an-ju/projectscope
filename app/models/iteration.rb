class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  # abstract the graph with the same iteration id
  def abstract_graph
    @tasks = Task.where(iteration: self.id)
    graph = Hash.new
    @tasks.each { |task| graph[task.id] = Taskedge.find_children task }
    # JSON.generate(graph)
    graph
  end

  # return the graph rank
  def self.graph_rank graph
    level = 0
    graphlevel = Hash.new
    root = Taskedge.find_root graph.keys
    graphlevel[root] = level
    children = graph[root]
    visited = Array.new(children)
    visited.append(root)
    children.each{ |child| graphlevel[child] = level + 1 }
    until children.empty?
      newnode = children.shift
      newchildren = graph[newnode]
      newchildren.each { |child| graphlevel[child] = graphlevel[newnode] + 1 }
      newchildren.delete_if { |child| visited.include? child }
      visited.concat(newchildren)
      children.concat(newchildren)
    end
    Iteration.level_up graphlevel,graph
  end

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

  #copy iteration assignment to the new project
  def self.copy_assignment iteration, projid
    newiter = Iteration.new()
    newiter.project_id = projid
    newiter.name = iteration.name
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
