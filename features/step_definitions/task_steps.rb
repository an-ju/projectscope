require 'json'
Given(/^the following task graph configs:$/) do |table|
  table.hashes.each do |hash|
    new_iteration = Iteration.new()
    new_iteration.name = hash['name']
    new_iteration.project_id = Project.find_by_name(hash['project']).id
    new_iteration.save
  end
end

Given /^"Github" default "started" task is mapped to "default branch"/ do
  @task = Task.new(title: "github branch task", task_status: "started", updater_type: "github",
              description: "this task is for testing the github call back")
  update_info = {}
  update_info[:branch_name] = "default branch"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /^"Github" updater receives information of the "default branch" is merge back from Event/ do
  @task = Task.find_by(title: "github branch task")
  update_info = JSON.parse @task.updater_info
  update_info[:branch_name].should equal?"default branch"
  @task.task_status.should equal? "started"
  @task.update_status
end

Then /I will be able to see the status of the "([^\"]*)" become finished/ do |task_title|
  @task = Task.find_by(title: task_title)
  @task.task_status.should equal? "finished"
end

Given /"Pivotal" default "started" task is mapped to "default story"/ do
  @task = Task.new(title: "pivotal story task", task_status: "started", updater_type: "pivotal",
                   description: "this task is for testing the pivotal call back")
  update_info = {}
  update_info[:story_name] = "default story"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /"Pivotal" updater receives information of the "default story" is labeled as finished/ do
  @task = Task.find_by(title: "pivotal story task")
  update_info = JSON.parse @task.updater_info
  update_info[:story_name].should equal?"default story"
  @task.task_status.should equal? "started"
  @task.update_status
end

Given /"Local" default "started" task is mapped to "google form"/ do
  @task = Task.new(title: "Local google form task", task_status: "started", updater_type: "github",
                   description: "this task is for testing the github call back")
  update_info = {}
  update_info[:google_doc_link] = "temp_google_doc_link"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /"Local" updater receives information of a file is being submited/ do
  @task = Task.find_by(title: "Local google form task")
  update_info = JSON.parse @task.updater_info
  update_info[:google_doc_link].should equal?"temp_google_doc_link"
  @task.task_status.should equal? "started"
  @task.update_status
end


