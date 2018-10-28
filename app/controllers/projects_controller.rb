require 'json'


class ProjectsController < ApplicationController
  before_action :set_project, only: %I[show edit update destroy add_owner]
  before_action :init_existed_configs, only: %I[show edit new]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    if current_user.is_student?
      if current_user.project.nil?
        redirect_to init_user_path current_user
      else
        redirect_to project_path current_user.project
      end
    end
    days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    @days_from_now = days_from_now
    @current_page = params.key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.key?(:type) ? params[:type] : 'metric'
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    @days_from_now = days_from_now
    @current_page = params.key?(:page) ? (params[:page].to_i - 1) : 0
    @display_type = params.key?(:type) ? params[:type] : 'metric'
    @other_projects = Project.select(%I[id name]).where.not(id: @project.id)
  end

  # GET /projects/new
  def new
    @project = Project.new
    @credentials = ProjectMetrics.metric_names\
                       .flat_map { |m| ProjectMetrics.class_for(m).credentials }\
                       .uniq\
                       .group_by { |name| name.to_s.split('_')[0].to_sym }
  end

  # GET /projects/1/edit
  def edit
    @configs = {}
    ProjectMetrics.metric_names.each do |metric|
      all_configs = @project.config_for metric
      ProjectMetrics.class_for(metric).credentials.each do |c|
        config = all_configs.select { |m| m.metrics_params.eql? c.to_s }.first
        @configs[metric] ||= []
        @configs[metric] << { c => config.nil? ? '' : config.token }
      end
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    update_params = project_create_params
    config_params = update_params.delete 'configs'
    @project = Project.new(update_params)
    ProjectMetrics.metric_names.each do |m|
      ProjectMetrics.class_for(m).credentials.each do |param|
        if config_params.key? param.to_s
          @project.configs << Config.new(metric_name: m, metrics_params: param, token: config_params[param])
        end
      end
    end
    respond_to do |format|
      if @project.save
        current_user.preferred_projects << @project
        current_user.owned_projects << @project
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    update_params = project_update_params
    config_params = update_params.delete 'configs'
    notice = ''
    ProjectMetrics.metric_names.each do |m|
      ProjectMetrics.class_for(m).credentials.each do |param|
        next unless config_params[m].key? param.to_s
        config = @project.configs.where(metric_name: m, metrics_params: param).take
        if config
          config.token = config_params[m][param]
          notice += "Failed to update config #{config.metric_name}: #{config.metrics_params}\n" unless config.save
        else
          @project.configs << Config.new(metric_name: m, metrics_params: param, token: config_params[m][param])
        end
      end
    end
    @project.attributes = update_params
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' + notice }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /projects/:id/metrics/:metric/detail
  def show_metric
    @metric_name = params[:metric]

    @samples = @project.metric_samples
                       .select(%I[id project_id metric_name image score created_at]).limit(50)
                       .where(metric_name: @metric_name)
                       .sort_by { |elem| Time.now - elem.created_at }

    render template: 'projects/metric_detail'
  end

  def add_owner
    new_username = params[:username]
    new_owner = User.find_by_provider_username new_username
    if current_user.is_owner_of? @project and !new_owner.nil?
      begin
        @project.owners << new_owner
        flash[:notice] = "#{new_username} has become an owner of this project!"
      rescue
        flash[:alert] = "Failed to add #{new_username} as owner."
      end
    end
    redirect_to project_path(@project)
  end

  # POST /log
  def write_log
    logger.info "Log from remote: #{params['message']}"
    render json: { message: 'Success' }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.includes(:configs).find(params[:id])
  end

  def init_existed_configs
    @existed_configs = {}
    ProjectMetrics.metric_names.each do |name|
      @existed_configs[name] = []
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_create_params
    params.require(:project).permit([:name, :user_id, configs: allowed_configs])
  end

  def project_update_params
    params.require(:project)
  end

  def allowed_configs
    ProjectMetrics.metric_names
        .flat_map { |m| ProjectMetrics.class_for(m).credentials }
        .uniq
  end

  def days_ago(t)
    (Time.now - t).to_i / (24*3600)
  end
end
