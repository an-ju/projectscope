class TaskUpdate < ActiveRecord::Base
    belongs_to :student_task
    belongs_to :user
    def getUpdate
        return user.provider_username+" updated from "+before+" to "+after
    end
end
