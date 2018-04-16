require 'faraday'

class IterationsController < ApplicationController
  before_action :set_iteration, only: [:show, :edit, :update, :destroy]

  # GET /iterations
  # GET /iterations.json
  def index
    @iterations = Iteration.all
  end

  # GET /iterations/1
  # GET /iterations/1.json
  def show
    # @graph = @iteration.abstract_graph
    @tasks = Task.where(iteration: @iteration.id)
    @preliminaryTasks = @tasks.select{|task| task.updater_type == 'preliminary'}
    @devTasks = @tasks.select{|task| task.updater_type == 'development'}
    @postTasks = @tasks.select{|task| task.updater_type == 'post'}
    # @level = Iteration.graph_rank @graph
    # @maxelem = Iteration.max_level_elem @level
  end

  # GET /iterations/new
  def new
    @iteration = Iteration.new
  end

  # GET /iterations/1/edit
  def edit
  end

  # POST /iterations
  # POST /iterations.json
  def create
    @iteration = Iteration.new(iteration_params)

    respond_to do |format|
      if @iteration.save
        format.html { redirect_to @iteration, notice: 'Iteration was successfully created.' }
        format.json { render :show, status: :created, location: @iteration }
      else
        format.html { render :new }
        format.json { render json: @iteration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iterations/1
  # PATCH/PUT /iterations/1.json
  def update
    respond_to do |format|
      if @iteration.update(iteration_params)
        format.html { redirect_to @iteration, notice: 'Iteration was successfully updated.' }
        format.json { render :show, status: :ok, location: @iteration }
      else
        format.html { render :edit }
        format.json { render json: @iteration.errors, status: :unprocessable_entity }
      end
    end
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
