require 'json'
Given(/^the following task graph configs:$/) do |table|
  table.hashes.each do |hash|
    new_iteration = Iteration.new()
    new_iteration.name = hash['name']
    new_iteration.project_id = Project.find_by_name(hash['project']).id
    new_iteration.save
  end
end

Given /^"Github" default "unfinished" task is mapped to default branch/ do
  @task = Task.new(title: "github task", task_status: "started", updater_type: "github",
              description: "this task is for testing the github call back")
  update_info = {}
  update_info[:branch_name] = "default branch"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /^"Github" updater receives information of the default branch is merge back from Event/ do
  @task = Task.find_by(title: "github task")
  update_info = JSON.parse @task.updater_info
  update_info[:branch_name].should equal?"default branch"
  @task.task_status.should equal? "started"
  @task.update_status
end

Then /I will be able to see the the status of the "Github" default "unfinished" task become finished/ do
  @task = Task.find_by(title: "github task")
  @task.task_status.should equal? "finished"
end