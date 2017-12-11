class StudentTaskController < ApplicationController
    #load the form for new task
    #show the tasks for a team for a selected the iteration
    def index
        @team = current_user.project
        @iter = params[:iter]
        @iteration = Iteration.find_by(id: @iter)
        @project = @team
        
        puts("--------------------------------------")
        puts(@iter)
        puts(@iteraion)
        
        @iteration_comments = @iteration.get_comments(@team)
        
        #testing only purpose
        if @team==nil
            @team = Project.all[0]
        end
        
        @tasks = StudentTask.level_search(@iter, @team.id)
        #to do : display the tasks in the view
        
    end
    #retrive the form for adding a new customized task for a team/project
    def new
        team_id = params[:team]
        @team = Project.find(team_id)
        iteration_id = params[:iter]
        @iteration = Iteration.find(iteration_id)
        @all_tasks = StudentTask.where('iteration_id': iteration_id, 'project_id': team_id)
        
    end
    #save the new task
    def create
        team_id = params[:team]
        @team = Project.find(team_id)
        iteration_id = params[:iter]
        @iteration = Iteration.find(iteration_id)
        new_added = StudentTask.new
        new_added.iteration = @iteration
        new_added.project = @team
        task_param = params[:task]
        parents_param = params[:tasks]
        new_added.title = task_param[:title]
        new_added.description = task_param[:description]
        new_added.save!
        @tasks = StudentTask.where('iteration_id': iteration_id, 'project_id': team_id)
        if !@tasks
            @tasks =[]
        end
        @tasks.each do |p|
            if !p.title.nil? 
                if !parents_param.nil? and parents_param[p.title]=="true"
                    new_added.add_parent(p)
                end
            end
        end
   
        ##need to add display message and direct to some page 
        flash[:message]= "Successfully create the task"
        redirect_to   show_a_team_path(:iter =>params[:iter],:team => params[:team])
    
    end
    def destroy
        @target = StudentTask.find(params[:id])
        iter_id=@target.iteration_id
        team_id=@target.project_id
        if @target !=nil
            @target.destroy
        end
        flash[:message]= "Successfully delete the task"
        redirect_to show_a_team_path(:iter =>iter_id,:team =>team_id)
    end
    #retrive the form for editing a task(instructor only)
    def edit
        @task = StudentTask.find(params[:id])
        @parents = StudentTask.where('iteration_id': @task.iteration_id, 'project_id': @task.project_id)
        #to do : display the task in the view
        @selected_parents = @task.parents
        @task_comments = @task.comments
        @project = @task.project
    end
    
    #save the change made by an instructor
    def saveChange
        @target_task = StudentTask.find(params[:id])
        #get all the information from the form submitted and save the change to targe task
     
        @tasks = StudentTask.where('iteration_id': @target_task.iteration_id, 'project_id': @target_task.project_id)
        if !@tasks
            @tasks =[]
        end
        parents_param = params[:tasks]
        task_param = params[:task]
        @target_task.title = task_param[:title]
        @target_task.description = task_param[:description]
        @target_task.parents.clear
        @target_task.save!
        @tasks.each do |p|
            if !p.title.nil? 
                if !parents_param.nil? and parents_param[p.title]=="true"
                    @target_task.add_parent(p)
                end
            end
        end
   
        ##need to add display message and direct to some page 
        flash[:message]= "Successfully saved the change"
        ## to do: need to redirect but need to show the team view but not implemented yet
        redirect_to show_a_team_path(:iter =>@target_task.iteration_id,:team => @target_task.project_id)
    end
    
    #change the status of a task from student

    def update_status
          task = StudentTask.find( params[:id])
          statusKey =task.title+"status"
        if(task.status==params[statusKey])
            redirect_to team_index_path(task.iteration_id)
            return 
        else
            puts task.title+"status"+params[statusKey]
            history = TaskUpdate.new
            history.user_id=current_user.id
            history.before = task.status
            history.after = params[statusKey]
            history.student_task_id=task.id
            history.save
            task.status = (params[statusKey])
            task.save
            redirect_to team_index_path(task.iteration_id)
        end
    end
    
    #show the detailed graph of a team for instructor
    def showATeamForInstructor
        @team = Project.find(params[:team])
        @iter = params[:iter]
        @tasks = StudentTask.topological_sort(@iter, @team.id)
        @iteration = Iteration.find_by(id: @iter)
        @project = @team
        @iteration_comments = @iteration.get_comments(@team)

        #todo: diplay the tasks 
    end
    
    def task_read
        comments = Comment.where(student_task_id: params["id"].to_i)
        for cmnt in comments
          cmnt.read_comment(current_user)
        end
        @comment = cmnt
        render "comments/show/", status: :ok, location: cmnt
    end
end
