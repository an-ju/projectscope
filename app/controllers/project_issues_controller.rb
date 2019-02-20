class ProjectIssuesController < ApplicationController
  before_action :set_project

  # GET /projects/1/project_issues
  def index
  end

  # GET /projects/1/project_issues/2
  def show
    @project_issue = @project.project_issues.find(params[:id])
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
