module ProjectsHelper
  def setup_metric_configs(project)
    ProjectMetrics.metric_names.each do |metric|
      if project.configs.where(:metric_name => metric).empty?
        project.configs.build(:metric_name => metric)
      end
    end
    project
  end

  def is_selected_metric? sample
    sample.try(:metric_name) != nil && (current_user.preferred_metrics.include? sample.metric_name)
  end

  def metric_content_class_label sample
    "metric-content " + (sample.created_at >= Date.today ? "" : "outdated-metric")
  end

  def hours_ago(t)
    (Time.now - t).to_i / 3600
  end

  def score_label(m)
    begin
      send("#{m.metric_name}_label", m.score)
    rescue NoMethodError
      'label-default'
    end
  end

  # TODO: move these methods into a generator that's called on initialization
  def github_files_label(score)
    if score > 2.5
      'label-success'
    elsif score > 1.5
      'label-warning'
    else
      'label-danger'
    end
  end
end
