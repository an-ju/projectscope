class RawData < ApplicationRecord
  belongs_to :project
  validates :name, presence: true
  validates :content, presence: true
  validates :project, presence: true

  def self.register(project, metric, data_version=nil)
    metric.raw_data.each do |key, value|
      record = project.raw_data.where(name: key, data_version: data_version)
      create(name: key, content: value, project: project, data_version: data_version) if record.empty?
    end
  end

  def self.get_data_for(metric_name, data_version)
    data_list = ProjectMetrics.class_for(metric_name).meta[:raw_data]
    return nil if data_list.nil?

    where(name: data_list, data_version: data_version).inject({}) do |dhash, d|
      dhash.update({ d.name => d.content })
    end
  end

end
