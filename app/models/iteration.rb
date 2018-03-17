class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  # abstract the graph with the same iteration id
  def self.abstract_graph iteration_id
    tasks = Task.where(iteration: iteration_id)
    graph = Hash.new
    tasks.each { |task| graph[task.id] = Taskedge.find_children task }
    # JSON.generate(graph)
    graph
  end

  def self.abstract_graph_parent iteration_id
    tasks = Task.where(iteration: iteration_id)
    graph = Hash.new
    tasks.each { |task| graph[task.id] = Taskedge.find_parents task }
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

  # Find out the height and length of the graph
  def self.max_level_elem ranklist
    ranklist.map{ |list| list.length }.max
  end
end
