class RawData < ApplicationRecord
  belongs_to :project

  def self.register(metric)
    metric.raw_data.each do |key, value|
      create(name: key, content: value)
    end
  end

end
