class Task < ActiveRecord::Base
  has_many :inedge, class_name: "Task", foreign_key: "outedge_id"
  belongs_to :outedge, class_name: "Task", foreign_key: "inedge_id"

end
