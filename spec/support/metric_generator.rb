module MetricGenerator
  def generic_metric
    metric = double('metric',
                    image: { chartType: 'test', data: {} },
                    score: 1.0,
                    raw_data: { test: { value: 0 } } )
    allow(metric).to receive(:refresh)
    metric
  end
end