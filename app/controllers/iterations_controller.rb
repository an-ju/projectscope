require 'faraday'

class IterationsController < ApplicationController
  before_action :set_iteration, only: [:show, :edit, :update, :destroy]

  # GET /iterations
  # GET /iterations.json
  def index
    @iterations = Iteration.all
    if current_user.is_student?
      redirect_to init_user_path current_user
    end
    @current_page = params.has_key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.has_key?(:type) ? (params[:type]) : 'metric'
    # @projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    @projects = Project.all
    @template_iterations = Iteration.where(template:true)
    # metric_min_date = MetricSample.min_date || Date.today
    # @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /iterations/1
  # GET /iterations/1.json
  def show
    @tasks = Task.where(iteration: @iteration.id)
    # @task_ddl = @iteration.task_ddl
    @preliminaryTasks, @devTasks, @postTasks = Task.tasks_selection @iteration
    @editable = !(current_user.is_student?)
    @prepercent, @devpercent, @postpercent, @predan, @devdan, @postdan =
        Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
    @devtaskTitles, @pretaskTitles, @postaskTitles = Task.phases_task
  end

  # POST /iterations
  # POST /iterations.json
  def create
    @iteration = Iteration.create(name: params[:template], template: true)
    redirect_to '/iterations'
  end

  # Function be call when Event is ready and send update request to Event
  def update_all
    @iteration = Iteration.find(params[:iteration_id])
    redirect_to @iteration
    # the following are temporarily commented as events is not deployed
    # response = Events::update_all
    # response_hash = JSON.parse(response)
    # Iteration.task_graph_update response_hash
  end

  # delete task
  def delete_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.destroy
    redirect_to @iteration
  end

  # Edit a single task
  def edit_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.description = params[:description]
    task.title = params[:title]
    task.save
    redirect_to @iteration
  end

  # Finalize the assignment of template to specific project with
  # starting and ending date
  def apply_to
    project = Project.find params[:project_id]
    newiter = Iteration.copy_assignment params[:id], project.id
    if not newiter
      respond_to do |format|
        format.html {redirect_to iterations_path, notice: 'Iteration Template copy failed.'}
      end
    elsif not newiter.set_timestamp params[:start_time], params[:end_time]
      newiter.destroy
      respond_to do |format|
        format.html { redirect_to iterations_path, notice: 'Failed. Please put in the start and end time according to the implied structure.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to iterations_path, notice: 'Project was successfully assigned.' }
      end
    end
  end

  # Apply the assignment to all projects selected
  def apply_to_all
    projects = params[:projects].split(' ')
    projects.each do |project|
      newiter = Iteration.copy_assignment params[:iteration_id], project
      newiter.set_timestamp params[:start_time], params[:end_time]
    end
    respond_to do |format|
      format.html { redirect_to iterations_path, notice: 'Projects was successfully assigned.' }
    end
  end

  # The Dashboard that is presenting all the iterations of all projects
  def dashboard
    if current_user.is_student?
      redirect_to init_user_path current_user
    end
    @progress = Iteration.task_progress
    @tasks_iter = Iteration.collect_current_tasks
  end

  # Present and modify the template iteration graph
  def show_template
    @iteration = Iteration.find(params[:id])
    @editable = !(current_user.is_student?)
    @prepercent, @devpercent, @postpercent, @predan, @devdan, @postdan =
        Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
    @devtaskTitles, @pretaskTitles, @postaskTitles = Task.phases_task
    @preliminaryTasks, @devTasks, @postTasks = Task.tasks_selection @iteration
  end

  # Select projects that among all for assigning the template
  def select_projects
    @iteration = Iteration.find(params[:id])
    @projects = Project.all
  end

  # Create the task in timeline
  def create_task
    @iteration = Iteration.find params[:iteration_id]
    Task.create_task params
    redirect_to @iteration
  end

  # create new task in template
  def create_template_task
    @iteration = Iteration.find params[:iteration_id]
    Task.create_task params
    redirect_to show_iter_temp_path(@iteration.id)
  end

  # confirm assignment and select starting and ending date for project
  def confirm_assignment
    project_ids = params[:project_ids].collect {|id| id.to_i} if params[:project_ids]
    @iteration = Iteration.find(params[:id])
    @projects = project_ids.map{|proj| Project.find(proj)}
  end

  # Delete iteration template
  def delete_iteration
    @iteration = Iteration.find(params[:id])
    @iteration.destroy
    redirect_to iterations_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iteration
      @iteration = Iteration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iteration_params
      params.fetch(:iteration, {})
    end
end
