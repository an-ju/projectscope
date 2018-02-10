class Taskedge < ActiveRecord::Base
  belongs_to :childtask, foreign_key: :childtask_id, class_name: "Task"
  belongs_to :parenttask, foreign_key: :parenttask_id, class_name: "Task"
end