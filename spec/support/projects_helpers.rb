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
end