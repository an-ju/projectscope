require 'faraday'

class IterationsController < ApplicationController
  before_action :set_iteration, only: %i[show edit update destroy]

  # GET /iterations
  # GET /iterations.json
  def index
    @iterations = Iteration.all
  end

  # GET /iterations/new
  # GET /iterations/new.json
  def new
    @iteration = Iteration.new
  end

  # GET /iterations/1
  # GET /iterations/1.json
  def show
    @tasks = Task.where(iteration: @iteration.id)
    # @task_ddl = @iteration.task_ddl
    @titles = {}
    @tasks = {}
    @titles[:requestingTitles], @titles[:planningTitles], @titles[:executionTitles], @titles[:deliveringTitles] = Task.phases_task
    @tasks[:requestingTasks], @tasks[:planningTasks], @tasks[:executionTasks], @tasks[:deliveringTasks] =
      Task.tasks_selection @iteration
    @project = Project.find(@iteration.project_id)
    @editable = !current_user.is_student?
    @percentage = Iteration.percentage_progress @tasks
  end

  # POST /iterations
  # POST /iterations.json
  def create
    iteration_params = params[:iteration]
    if iteration_params[:apply_to_all]
      project_list = Project.all.map(&:id)
    else
      project_list = [iteration_params[:project]]
    end

    project_list.each do |pid|
      Iteration.create( project_id: pid,
                        start_time: iteration_params[:start_time],
                        end_time: iteration_params[:end_time],
                        name: iteration_params[:name] )
    end

    redirect_to iterations_path
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

  # Apply the assignment to all projects selected
  def apply_to_all
    if !validate_date
      copy_reset_time
    else
      assign_success
    end
  end

  # The Dashboard that is presenting all the iterations of all projects
  def dashboard
    redirect_to init_user_path current_user if current_user.is_student?
    @progress = Iteration.task_progress
    @tasks_iter = Iteration.collect_current_tasks
  end

  # Present and modify the template iteration graph
  def show_template
    @iteration = Iteration.find(params[:id])
    @titles = {}
    @tasks = {}
    @titles[:requestingTitles], @titles[:planningTitles], @titles[:executionTitles], @titles[:deliveringTitles] = Task.phases_task
    @tasks[:requestingTasks], @tasks[:planningTasks], @tasks[:executionTasks], @tasks[:deliveringTasks] =
      Task.tasks_selection @iteration
  end

  # Select projects that among all for assigning the template
  def select_projects
    @iteration = Iteration.find(params[:id])
    @projects = Project.all
  end

  # Create the task in timeline
  def create_task
    @iteration = Iteration.find params[:iteration_id]
    Task.create params
    redirect_to @iteration
  end

  # create new task in template
  def create_template_task
    @iteration = Iteration.find params[:iteration_id]
    Task.create params
    redirect_to show_iter_temp_path(@iteration.id)
  end

  # confirm assignment and select starting and ending date for project
  def confirm_assignment
    project_ids = params[:project_ids].collect(&:to_i) if params[:project_ids]
    @iteration = Iteration.find(params[:id])
    @projects = project_ids.map { |proj| Project.find(proj) }
  end

  # Delete iteration template
  def delete_iteration
    @iteration = Iteration.find(params[:id])
    @iteration.destroy
    redirect_to iterations_path
  end

  private

  # successfully copy
  def assign_success
    projects = params[:projects].split(' ')
    projects.each do |project|
      newiter = Iteration.copy_assignment params[:iteration_id], project
      newiter.set_timestamp params[:start_time], params[:end_time]
    end
    respond_to do |format|
      format.html { redirect_to iterations_path, notice: 'Projects were successfully assigned.' }
    end
  end

  # time stamp fail
  def copy_reset_time
    @iteration = Iteration.find(params[:iteration_id])
    @projects = params[:projects].split(' ').map { |proj| Project.find(proj) }
    respond_to do |format|
      format.html { redirect_to iterations_path, notice: 'Failed. Please put in the start and end time according to the implied structure.' }
    end
  end

  # Validate_date
  def validate_date
    (/(?<year>\d{4})\/(?<month>\d{1,2})\/(?<day>\d{1,2})/.match(params[:start_time]) &&
        /(?<year>\d{4})\/(?<month>\d{1,2})\/(?<day>\d{1,2})/.match(params[:end_time]))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_iteration
    @iteration = Iteration.find(params[:id])
  end

end
