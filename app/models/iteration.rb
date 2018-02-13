class Iteration < ActiveRecord::Base
  belongs_to :project
  has_many :tasks

  # abstract the graph with the same iteration id
  def self.abstract_graph iteration_id
    tasks = Task.where(iteration: iteration_id)
    graph = Hash.new
    tasks.each{|task| graph[task.id] = Taskedge.find_children task}
    # JSON.generate(graph)
    graph
  end
end
