require 'faraday'

class IterationsController < ApplicationController
  before_action :set_iteration, only: [:show, :edit, :update, :destroy]

  # GET /iterations
  # GET /iterations.json
  def index
    @iterations = Iteration.all
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @current_page = params.has_key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.has_key?(:type) ? (params[:type]) : 'metric'
    # @projects = current_user.preferred_projects.empty? ? Project.all : current_user.preferred_projects
    @projects = Project.all
    @tasks = Task.where(iteration: 2)
    # metric_min_date = MetricSample.min_date || Date.today
    # @num_days_from_today = (Date.today - metric_min_date).to_i
  end

  # GET /iterations/1
  # GET /iterations/1.json
  def show
    # @graph = @iteration.abstract_graph
    @tasks = Task.where(iteration: @iteration.id)
    @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
    @devTasks = @tasks.select{|task| task.updater_type == 'development'}
    @postTasks = @tasks.select{|task| task.updater_type == 'post'}
    @editable = !(current_user.is_student?)
    @prepercent, @devpercent, @postpercent, @predan, @devdan, @postdan =
        Iteration.percentage_progress @preliminaryTasks, @devTasks, @postTasks
    @devtaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                     'Finish Story', 'TDD and BDD', 'Points Estimation',
                     'Pull Request'].freeze
    @pretaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                     'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
    @postaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
    # @level = Iteration.graph_rank @graph
    # @maxelem = Iteration.max_level_elem @level
  end

  # GET /iterations/new
  def new
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @iteration = Iteration.new
    @projects = Project.all
  end

  # GET /iterations/1/edit
  def edit
  end

  # POST /iterations
  # POST /iterations.json
  def create
  end

  # PATCH/PUT /iterations/1
  # PATCH/PUT /iterations/1.json
  def update
  end

  # DELETE /iterations/1
  # DELETE /iterations/1.json
  def destroy
    @iteration.destroy
    respond_to do |format|
      format.html { redirect_to iterations_url, notice: 'Iteration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_all
    @iteration = Iteration.find(params[:iteration_id])
    redirect_to @iteration
    # the following are temporarily commented as events is not deployed
    # response = Events::update_all
    # response_hash = JSON.parse(response)
    # Iteration.task_graph_update response_hash
  end

  def iteration_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    if Task.no_update? task
      redirect_to @iteration, notice: 'Uable to update as parent not fiinished.'
    else
      Task.update_status task
      redirect_to @iteration
    end
  end

  def iteration_task_reset
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.reset_status
    redirect_to @iteration
  end

  def delete_task
    task = Task.find(params[:task_id])
    @iteration = Iteration.find(params[:iteration_id])
    task.destroy
    redirect_to @iteration
  end

  def create_task
    @iteration = Iteration.find params[:iteration_id]
    newtask = Task.new
    newtask.updater_type = params[:updater_type]
    newtask.title = params[:title]
    newtask.task_status = "unstarted"
    newtask.iteration_id = params[:iteration_id]
    newtask.description = params[:description]
    newtask.save
    redirect_to @iteration
  end

  def aggregate_tasks_graph
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    @tasks = Task.where(iteration: 2)
    @projects = Project.all
  end

  def apply_to_all
    Iteration.all_copy_assignment params[:apply_all]
    redirect_to '/iterations'
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
