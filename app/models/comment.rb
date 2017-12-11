class Comment < ActiveRecord::Base
  belongs_to :metric_sample
  belongs_to :user
  belongs_to :project
  belongs_to :student_task
  belongs_to :iteration

  def update_metric_sample
    origin_image = JSON.parse(metric_sample.image)
    if origin_image['data'].has_key? 'score'
      origin_image['data']['score'] = content.to_f
    end
    metric_sample.image = origin_image.to_json
    metric_sample.score = content.to_f
    metric_sample.save
  end

  def general_comment?
    self.ctype.eql? 'general_comment'
  end

  def unread?(current_user)
    if current_user.is_admin?
      return self.admin_read.eql? 'unread'
    else
      return self.student_read.eql? 'unread'
    end
  end
  
  def read_comment(current_user)
    if current_user.is_admin?
      self.admin_read = 'read'
    else
      self.student_read = 'read'
    end
    self.save!
  end
  
  def metric_name
    name = metric
    name.gsub!(/_/, ' ')
    name.split.map(&:capitalize).join(' ')
  end
end
