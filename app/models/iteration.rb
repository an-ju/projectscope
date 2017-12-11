class Iteration < ActiveRecord::Base
    has_many :comments
    
    def get_comments(project)
        Comment.where(iteration_id: self.id, project_id: project.id)
    end
end
