##Schema For Task
#title |string
#description |string
#iteration |iteration
#parents |Task[]
class Task < ActiveRecord::Base
    has_many :parents, class_name: "Task"
    belongs_to :iteration
    # add an existing tasks to parents tasks
    def add_parent(p)
        self.parents.push(p)
        self.save
    end
    # add an list of tasks to parents tasks
    # def add_parents(parents)
    #     parents.each do|p|
    #         self.parents.push(p)
    #     end
    #     self.save
    # end
end
