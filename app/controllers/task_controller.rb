class TaskController < ApplicationController
    #load the form for new task
    def new
        #get the iteration going to be added to
        @iteration = Iteration.find(params[:iter])
        #get the list of current tasks in the iteration selected
        @all_tasks =  Task.where('iteration_id': params[:iter]).uniq.pluck(:title)
    end
    def publish
        @iteration = Iteration.find(params[:iter])
        @all_tasks =  Task.where('iteration_id': params[:iter])
        #to do : eliminate all the copied task
        all_old_copied_tasks = StudentTask.where('iteration_id': params[:iter])
        all_old_copied_tasks.each do|e|
            e.destroy
        end
        #to do : copy the tasks to all the teams
        Project.all.each do |team|
            map = Hash.new
            # copy the tasks for a team
            @all_tasks.each do|t|
                new_student_task = StudentTask.new
                new_student_task.project = team
                new_student_task.title = t.title
                new_student_task.description = t.description
                new_student_task.iteration = t.iteration
                new_student_task.save
                map[t.id]=new_student_task
            end
            # copy the parents 
             @all_tasks.each do|t|
                new_task = map[t.id]
                t.parents.each do |p|
                    new_task.add_parent(map[p.id])
                end
            end
        end
        redirect_to show_iteration_path(params[:iter])
    end
    def task_student_show
        @iteration = Iteration.find(params[:iter])
        #get the list of current tasks in the iteration selected
        @tasks =  Task.where('iteration_id': params[:iter])
    end
    #create new tasks
    def create
        @iteration = Iteration.find(params[:iter])
        @tasks = Task.where('iteration_id': params[:iter])
        parants_param = params[:tasks]
        task_param = params[:task]
        if task_param[:title].nil?or task_param[:description].nil? or task_param[:title].empty? or task_param[:description].empty?
            flash[:message]="Please fill in all required fields"
            puts("redirect because empty")
            redirect_to new_task_view_path(params[:iter])
            return
        end
        new_task = Task.new
        new_task.title=task_param[:title]
        new_task.description=task_param[:description]
        new_task.iteration = @iteration
        new_task.save
        #added all the checked tasks to parents
        @tasks.each do |p|
            if !p.title.nil? 
                if !parants_param.nil? and parants_param[p.title]=="true"
                    new_task.add_parent(p)
                end
            end
        end
        ##need to add display message and direct to some page 
        flash[:message]= "Successfully created task"
        puts(edit_iteration_path(params[:iter]))
        redirect_to edit_iteration_path(params[:iter])
    end

    #edit an existing task
    def edit
        @task = Task.find( params[:id])
        @all_parents =  Task.where('iteration_id': @task.iteration_id)
        @selected_parents = @task.parents
    end
    
  
    
    def update
        @task = Task.find( params[:id])
        @tasks = Task.where('iteration_id': @task.iteration_id)
        parants_param = params[:tasks]
        task_param = params[:task]
        @task.title = task_param[:title]
        @task.description = task_param[:description]
        @task.parents.clear
        @task.save!
        @tasks.each do |p|
            if !p.title.nil? 
                if !parants_param.nil? and parants_param[p.title]=="true"
                    @task.add_parent(p)
                end
            end
        end
   
        ##need to add display message and direct to some page 
        flash[:message]= "Successfully saved the changes"
   
        redirect_to show_iteration_path(@task.iteration_id)
    
        #retreive form submission paramaters from the total paramaters
        # task_params = params["task"]
        # to_sub = {} #this is the new array we will pass to Task to create a new iteration
        # to_sub["title"] = task_params["title"]
        # to_sub["description"] = task_params["description"]
        # # 2. to do: extract updated parents from  params
        # #to_sub["parent"] = task_params["..."]
        # @task = Task.find(params[:id])
        # @iteration = @task.iteration.id
        # @task.update_attributes!(to_sub)
        # @selected_parents = @task.parents
        # @all_parents = Task.where('iteration_id': params[:iter]).uniq.pluck(:title)
        
        # redirect_to edit_iteration_path(@iteration)
    end
  
    def destroy
        @task = Task.find(params[:id])
        @iteration = @task.iteration.id
        Task.find(params[:id]).destroy
        redirect_to edit_iteration_path(@iteration)
    end

end
