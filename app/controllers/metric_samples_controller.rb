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
    metric_sample.comments.each do |cmnt|
      cmnt.read_comment(current_user)
    end
    @comment = metric_sample.comments.first #TODO: Unsure what this @comment is used for.
    render json: { status: :ok }
    # render "comments/show/", status: :ok
  end

  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
