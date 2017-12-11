class IterationsController < ApplicationController
  
  def show
    @iteration = Iteration.find(params[:id])
    @tasks = Task.where('iteration_id': @iteration.id)
    @teams = Project.all
    @student_tasks = StudentTask.where('iteration_id': @iteration.id)
  end
  
  def index
    puts current_user.role
    if current_user.is_student?
      # or current_user.is_admin?
     
      redirect_to student_iteration_path()
      return
    end
    @iterations = Iteration.order(id: :asc).reverse_order.limit(10)
  end
  
  def create
    #create a new, default Iteration and redirect to the edit page for that iteration
    require "date"
    n = Iteration.create!(:name => "new_iteration", :start => Date.today, :end => Date.today + 7)
    redirect_to edit_iteration_path(n.id)
  end
  
  def student_show
    @iterations = Iteration.order(id: :asc).reverse_order.limit(10)
  end
  
  def edit
  
    @iteration = Iteration.find(params[:id])
    @iterations = Iteration.all
    @tasks = Task.where('iteration_id': params[:id])
    # @tasks = Task.joins(:iteration).where('iteration_id': params[:id])
    @tasks.each do|e|
      puts e.title
      puts e.iteration_id
    end
    # @tasks = Task.joins(:iteration).where('iteration_id' ,@iteration.id)


  end
  
  def update
    
    #retreive form submission paramaters from the total paramaters
    iteration_params = params["iteration"]
    to_sub = {} #this is the new array we will pass to Iteration to create a new iteration
    to_sub["name"] = iteration_params["name"]
    #We need to make a single date object from the three string objects that iteration_params contains
    to_sub["start"] = Date.new(iteration_params["start(1i)"].to_i, iteration_params["start(2i)"].to_i, iteration_params["start(3i)"].to_i)
    to_sub["end"] = Date.new(iteration_params["end(1i)"].to_i, iteration_params["end(2i)"].to_i, iteration_params["end(3i)"].to_i)
    @iteration = Iteration.find params[:id]
    @iteration.update_attributes!(to_sub)
    redirect_to show_iteration_path(params[:id])
  end
  
  def destroy
    Iteration.find(params[:id]).destroy
    redirect_to iterations_path
  end
  
  def copy
    @to = Iteration.find(params[:id])
    @selected_params = params[:iterations]
    @iterations = Iteration.all
    @iterations.each do|i|
      if @to.id != i.id && @selected_params[i.id.to_s]=="true"
        @tasks = Task.where('iteration_id': i.id)
        map = {}
        @tasks.each do|t|
          new_task = Task.new
          new_task.title= t.title
          new_task.description = t.description
          new_task.iteration_id = @to.id
          new_task.save
          map[t.id]=new_task
        end
        @tasks.each do|t|
          target = map[t.id]
          t.parents.each do|p|
            if map[p.id] !=nil
             target.add_parent(map[p.id])
           end
          end
        end
      end
    end
    redirect_to edit_iteration_path(@to.id)
  end
end
