Given(/the following users exist:/) do |users_table|
  users_table.hashes.each do |user|
    
    u = User.create!(password: Devise.friendly_token[0,20],
                 preferred_metrics: [],
                 preferred_projects: [],
                 project: Project.find_by(name: user["project"]),
                 role: user_type_from_string(user["role"]),
                 provider_username: user["provider_username"],
                 uid: user["uid"],
                 email: user["email"],
                 provider: user["provider"]
                 )

  end
end

Given(/the following comments exist:/) do |comments_table|
  
  comments_table.hashes.each do |comment|
    if comment["project"] == "nil"
      p_id = nil
    else
      p_id = Project.find_by(name: comment["project"]).id
    end
    
    if comment["student_task"] == "nil"
      st_id = nil
    else
      st_id = StudentTask.find_by(title: comment["student_task"]).id
    end
      
    if comment["iteration"] == "nil"
      i_id = nil
    else
      i_id = Iteration.find_by(name: comment["iteration"]).id
    end
    
    c = Comment.create!(metric_sample_id: comment["metric_sample"],
                        user_id: User.find_by(uid: comment["user"]),
                        ctype: "general_comment",
                        content: comment["content"],
                        created_at: DateTime.now,
                        updated_at: DateTime.now,
                        status: "unread",
                        project_id: p_id,
                        student_task_id: st_id,
                        iteration_id: i_id,
                        metric: comment["metric"],
                        admin_read: comment["admin_read"],
                        student_read: comment["student_read"]
                 )

  end
end


#helper for creating users
def user_type_from_string(string)
  if string == "student"
    return User::STUDENT
  elsif string == "admin"
    return User::ADMIN
  else
    raise "user_type_from_string requires 'student' or 'admin' got: '#{string}'"
  end
end

Given(/the following metrics samples exist:/) do |metrics_table|
  
  d = DateTime.now
  metrics_table.hashes.each do |metric|
    m = MetricSample.create!(:metric_name => metric["metric_name"],
                             :project_id => Project.find_by(name: metric["project"]).id,
                             :score => metric["score"],
                             :image => File.read('./db/fake_data/slack2.json'),
                             :created_at => d)
    Config.create(:metric_name => metric["name"],
                  :project_id => Project.find_by(name: metric["project"]).id,
                  :token => (0...50).map { ('a'..'z').to_a[rand(26)] }.join)
    d = d.prev_day
  end

end

Given(/I am "(.*)" and logged in/) do |name|
  
  user = User.find_by(uid: name)
  if user.role == "student"
    ENV['ADMIN_PASSWORD'] = 'password'
    visit "/login/#{user.uid}?passwd=password"
    
  elsif user.role == "admin"
    ENV['ADMIN_PASSWORD'] = 'password'
    visit "/login/#{user.uid}?passwd=password"
    
  #elsif type == "admin"
  #  admin_user = User.create!(provider_username: "Admin#{num}", uid: "uadmin#{num}", email: "uadmin#{num}@example.com",
  #                            provider: "developer", role: User::ADMIN, password: Devise.friendly_token[0,20])
  #  ENV['ADMIN_PASSWORD'] = 'password'
  #  visit "/login/#{admin_user.uid}?passwd=password"
    
  else
    raise "type must be 'student' or 'admin', got '#{name}'"
  end
end

#Since comments are tied to metric samples, not metrics. We will take this comment to be on the most reacent sample of this metric on this project
Given(/there is a "(.*)" comment "(.*)" on project "(.*)" metric "(.*)"/) do |user, comment, project, metric|
    require 'date'
    project = Project.find_by(name: project)
    metric_sample = project.latest_metric_sample(metric)
    this_user = User.find_by(uid: user)
    if this_user.is_admin?
      a_read = 'read'
      s_read = 'unread'
    else
      a_read = 'unread'
      s_read = 'read'
    end
    this_user = this_user.id
    
    Comment.create!(metric_sample_id: metric_sample.id, 
                    user_id: this_user,
                    ctype: 'general_comment',
                    params: '{}',
                    created_at: Date.today,
                    content: comment,
                    student_read: s_read,
                    admin_read: a_read)
end

When /^(?:|I )fill in the "([^"]*)" comment box with "([^"]*)"$/ do |num, value|
  num = num[0].to_i 
  within("form#sample_#{num}_form",  visible: false) do
    fill_in("content", :with => value,  visible: false)
  end
end

When /^(?:|I )click the "(.*)" "(.*)" link/ do |num, link|
  num = num[0].to_i 
  within("tr#buttons_#{num}") do
    find("#add_reply_button").click
  end
end

When /^(?:|I )submit form number "(.*)"$/ do |num|
  num = num.to_i 
  within("form#sample_#{num}_form",  visible: false) do
    click_button("Reply",  visible: false)
  end
end

Then /^there should be metric "(.*)"$/ do |num|
  page.should have_css("div#project-1-ondate-code_climate-#{num}")
end


Then /^there should not be metric "(.*)"$/ do |num|
  page.should_not have_css("div#project-1-ondate-code_climate-#{num}")
end

And /^I print page/ do
  print(page.body)
end

And /^I Mark All Read for the "(.*)" comment thread "(.*)"$/ do |thread_type, num|
    within("tr##{thread_type}_#{num}_buttons") do 
      find('.function_link', :text=>'Mark All Read').click
    end
end

Then /^I should have unread indicator/ do 
  page.should have_css("div#top-bar-comment-notice")
  
end

Then /^I should not have unread indicator/ do 
  page.should_not have_css("div#top-bar-comment-notice")
  
end

