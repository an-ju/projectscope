class MetricSamplesController < ApplicationController
  load_and_authorize_resource

  def index
    @metrics = ProjectMetrics.hierarchies :metric
    @projects = Project.all
    @metric_samples = @projects.map do |project|
      @metrics.flat_map { |m| project.metric_on_date m, date }
    end
  end

  def raw_data
    @metric_sample = MetricSample.find(params[:id])
    render json: @metric_sample.raw_data
  end
  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
