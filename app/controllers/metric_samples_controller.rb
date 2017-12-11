class MetricSamplesController < ApplicationController

  def index
    @metrics = ProjectMetrics.hierarchies :metric
    @projects = Project.all
    @metric_samples = @projects.map do |project|
      @metrics.flat_map { |m| project.metric_on_date m, date }
    end
  end
  
  def mark_read
    metric_sample = MetricSample.find_by(id: params["id"].to_i)
    for cmnt in metric_sample.comments
      cmnt.read_comment(current_user)
    end
    @comment = cmnt
    render "comments/show/", status: :ok, location: cmnt
  end

  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
