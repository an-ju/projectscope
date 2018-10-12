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
    new_rd = @metric_sample.raw_data.gsub(/[>:][ ]*(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} UTC)/) {|s| s[0] + '"' + $1 + '"'}
    render json: eval(new_rd)
  end

  # # GET /projects/:id/metrics/:metric
  # def get_metric_data
  #   #TODO: put this to the new controller
  #   days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
  #   date = Date.today - days_from_now.days
  #   metric = @project.metric_on_date params[:metric], date
  #   if metric.length > 0
  #     render json: metric.last
  #   else
  #     render :json => {:error => "not found"}, :status => 404
  #   end
  # end
  #
  # # GET /projects/:id/metrics/:metric/series
  # def get_metric_series
  #   #TODO: put it to the new controller
  #   metric_samples = @project.metric_samples.limit(3).where(metric_name: params[:metric])
  #   if metric_samples.empty?
  #     render json: { error: 'not found' }, status: 404
  #   else
  #     metric_samples = metric_samples.sort_by(&:created_at).map(&:attributes)
  #     metric_samples = metric_samples.map do |m|
  #       m.delete('encrypted_raw_data')
  #       m.delete('encrypted_raw_data_iv')
  #       m.update datetime: m['created_at'].strftime('%Y-%m-%dT%H:%M')
  #     end
  #     render json: metric_samples
  #   end
  # end

  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
