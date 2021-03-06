# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Project < ApplicationRecord
  has_many :configs
  has_many :metric_samples
  has_many :raw_data, class_name: 'RawData'
  has_and_belongs_to_many :users
  has_many :ownerships
  has_many :owners, class_name: 'User', through: :ownerships, source: :user
  has_many :project_issues
  has_many :iterations

  validates :name, presence: true, uniqueness: true

  accepts_nested_attributes_for :configs

  # scope :order_by_metric_score, -> (metric_name, order) {
  #   joins(:metric_samples).where("metric_samples.metric_name = ?", metric_name)
  #       .group(:id)
  #       .having("metric_samples.created_at = MAX(metric_samples.created_at)")
  #       .order("metric_samples.score #{order}") if ["ASC", "DESC"].include? order }
  # scope :order_by_name, -> (order) { order("name #{order}") if ["ASC", "DESC"].include? order }

  def config_for(metric)
    configs.where metric_name: metric
    # configs.where(:metric_name => metric).first || configs.build(:metric_name => metric)
  end

  def update_config(config_params)
    config = configs.where(metric_name: config_params[:metric_name],
                           metrics_params: config_params[:config_name]).first
    return false if config.nil?

    config.token = config_params[:config_value]
    config.save
  end

  # These two functions need further revisions.
  def all_metrics
    valid_configs = MetricSample.all.where(:project_id => id)
    return [] if valid_configs.nil?
    metrics_name_ary = []
    valid_configs.each do |config|
      metrics_name_ary << config.metric_name
    end
    metrics_name_ary.uniq
  end

  def latest_metric_sample(metric)
    metric_samples.latest_for metric
  end

  def metric_on_date(metric, date)
    metric_samples
      .select(%I[id project_id metric_name image score created_at])
      .where(created_at: (date.beginning_of_day.utc..date.end_of_day.utc), metric_name: metric)
  end

  def metric_series(metric, date)
    metric_samples
      .select(%I[id project_id metric_name score created_at])
      .where(created_at: ((date - 5.days).beginning_of_day.utc..date.end_of_day.utc), metric_name: metric)
  end

  def resample_all_metrics
    version_number = next_version_number
    ProjectMetrics.metric_names.each do |metric_name|
      resample_metric(metric_name, version_number)
    end
  end

  def resample_metric(metric_name, data_version=nil)
    metric = build_metric_for(metric_name, data_version)
    return if metric.nil?

    begin
      image = metric.image
      score = metric.score
    rescue Exception => e
      logger.fatal "(Compute) Metric #{metric_name} for project #{name} exception: #{e.message}"
      puts "(Compute) Metric #{metric_name} for project #{name} exception: #{e.message}"
      return
    rescue Error => err
      logger.fatal "(Compute) Metric #{metric_name} for project #{name} error: #{err.message}"
      puts "(Compute) Metric #{metric_name} for project #{name} error: #{err.message}"
      return
    end
    metric_samples.create!( metric_name: metric_name,
                            score: score,
                            image: image )
    RawData.register(self, metric, data_version)
  end

  def build_metric_for(metric_name, data_version)
    raw_data_record = raw_data.get_data_for(metric_name, data_version)
    credentials = get_credentials_for(metric_name)
    return nil if credentials.nil?

    begin
      ProjectMetrics.class_for(metric_name).new(credentials, raw_data_record)
    rescue Exception => e
      logger.fatal "(Initialize) Metric #{metric_name} for project #{name} exception: #{e.message}."
      puts "(Initialize) Metric #{metric_name} for project #{name} exception: #{e.message}."
      return nil
    rescue Error => err
      logger.fatal "(Initialize) Metric #{metric_name} for project #{name} error: #{err.message}."
      puts "(Initialize) Metric #{metric_name} for project #{name} exception: #{e.message}."
      return nil
    end
  end

  def get_credentials_for(metric_name)
    config_for(metric_name).inject(Hash.new) do |chash, config|
      return nil if config.nil? || config.token.empty?
      chash.update config.metrics_params.to_sym => config.token
    end
  end

  def self.latest_metrics_on_date(projects, preferred_metrics, date)
    projects.collect do |p|
      p.metric_samples
          .where(created_at: (date.beginning_of_day..date.end_of_day), metric_name: preferred_metrics)
          .map { |m| p.attributes.merge(m.attributes) }
    end
  end

  def next_version_number
    curr_version = raw_data.maximum(:data_version)
    curr_version.nil? ? 0 : curr_version + 1
  end

  def data_at(name, version)
    raw_data.where(name: name, data_version: version).first
  end

  def data_before(name, version)
    raw_data.where("name = '#{name}' AND data_version < #{version}").order(created_at: :desc).first
  end

  def current_iteration
    iterations.select { |iter| iter.start_time < Date.today && iter.end_time > Date.today }.first
  end

  def compute_issues
    curr_data_version = raw_data.maximum(:data_version)
    init_data_version = raw_data.where("created_at > ?", current_iteration.start_time).minimum(:data_version)

    ProjectIssue::ISSUES.each do |issue|
      ProjectIssue.send(issue, self, curr_data_version, init_data_version)
    end
  end

end
