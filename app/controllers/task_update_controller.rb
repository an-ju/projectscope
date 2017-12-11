class TaskUpdateController < ApplicationController
    def index
        @task = StudentTask.find(params[:id])
        @histories = TaskUpdate.where(:student_task_id =>@task.id)
        
        @task_comments = @task.comments
        @project = @task.project
    end
end