module Features
  def set_up_project_with_configs
    p = Project.create(name: 'test proejct', user_id: 1)
    metric_params.each do |metric, param|
      p.configs << Config.create(metric_name: metric, metrics_params: param,
                                 token: fake_config(metric, param))
    end
    p
  end

  def metric_params
    ProjectMetrics.metric_names.each do |metric|
      ProjectMetrics.class_for(metric).credentials do |cred|
        yield metric, cred
      end
    end
  end

  def fake_config(metric, param)
    "#{param} for #{metric}"
  end

  def seed_metric_samples
    project_list = [1, 2, 3].map do |index|
      Project.create(name: "project #{index}")
    end

    end_date = Date.today
    start_date = end_date - 7.days

    project_list.each_with_index do |project, index|
      start_date.upto(end_date) do |date|
        ProjectMetrics.metric_names.each do |metric|
          MetricSample.create(metric_name: metric,
                              project_id: project.id,
                              score: 0.1 * index,
                              image: image_metric_for(project, date, metric),
                              # raw_data: raw_data_for(project, date, metric),
                              created_at: date.beginning_of_day)
        end
      end
    end
  end

  def image_metric_for(project, date, metric)
    "image data of #{metric} for #{project.name} at #{date}"
  end

  def raw_data_for(project, date, metric)
    "raw data of #{metric} for #{project.name} at #{date}"
  end
end