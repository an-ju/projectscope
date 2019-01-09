# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'project_metric_code_climate'
# require 'project_metric_slack_trends'
# require 'project_metric_pivotal_tracker'

User.delete_all
Whitelist.delete_all
Project.delete_all
MetricSample.delete_all
Task.delete_all

projects_list = []
0.upto(10).each do |num|
  projects_list << Project.create!(name: "Project #{num}")
end


# create iteration
iteration = Iteration.create(name: "Iteration 0", template: true)
# create the seed for task graph
t1 = Task.create(title: 'Contact Customer',
                 iteration: iteration,
                 description: 'Some contents about Task 1',
                 task_status: 'finished',
                 updater_type: 'requesting',
                 duration: 4,
                 task_callbacks: 'hello_world')
t2 = Task.create(title: 'Customer Meeting',
                 iteration: iteration,
                 description: 'Some contents about Task 2',
                 task_status: 'finished',
                 updater_type: 'requesting',
                 task_callbacks: 'hello_world')
t4 = Task.create(title: 'Create Stories',
                 iteration: iteration,
                 description: 'Some contents about Task 4',
                 task_status: 'danger',
                 updater_type: 'requesting',
                 duration: 3,
                 task_callbacks: 'hello_world')

t5 = Task.create(title: 'Planning Meetings',
                 iteration: iteration,
                 description: 'Some contents about Task 5',
                 task_status: 'finished',
                 updater_type: 'planning',
                 task_callbacks: 'hello_world')
t6 = Task.create(title: 'Behavior Tests',
                 iteration: iteration,
                 description: 'Some contents about Task 6',
                 task_status: 'unstarted',
                 updater_type: 'planning',
                 duration: 5,
                 task_callbacks: 'hello_world')

t7 = Task.create(title: 'Unit Tests',
                 iteration: iteration,
                 description: 'Some contents about Task 7',
                 task_status: 'unstarted',
                 updater_type: 'execution',
                 task_callbacks: 'hello_world')
t8 = Task.create(title: 'Implementation',
                 iteration: iteration,
                 description: 'Some contents about Task 8',
                 task_status: 'started',
                 updater_type: 'execution',
                 duration: 6,
                 task_callbacks: 'hello_world')

t10 = Task.create(title: 'Pull Requests',
                 iteration: iteration,
                 description: 'Some contents about Task 8',
                 task_status: 'started',
                 updater_type: 'delivering',
                  duration: 4,
                 task_callbacks: 'hello_world')
t9 = Task.create(title: 'Code Review',
                 iteration: iteration,
                 description: 'Pass only get accepted by customers',
                 task_status: 'unstarted',
                 updater_type: 'delivering',
                 task_callbacks: 'hello_world')



end_date = Date.today
start_date = end_date - 7.days

Config.delete_all

projects_list.each do |project|
  ProjectMetrics.metric_names.each do |metric|
    start_date.upto(end_date) do |date|
      tcreate = date.to_time + 1.hour
      ProjectMetrics.class_for(metric).fake_data.shuffle.each do |d|
        MetricSample.create!( metric_name: metric,
                              project_id: project.id,
                              score: d[:score],
                              image: d[:image],
                              created_at: tcreate )
        tcreate += 4.hours
      end
    end
    ProjectMetrics.class_for(metric).credentials.each do |param|
      next unless rand > 0.5
      Config.create(metric_name: metric,
                    project_id: project.id,
                    token: (0...50).map { ('a'..'z').to_a[rand(26)] }.join,
                    metrics_params: param)
    end
  end
end

@user01 = User.create!(provider_username: "Admin", uid: "uadmin", email: 'uadmin@example.com',
                       provider: "developer", role: User::ADMIN, password: Devise.friendly_token[0,20],
                       preferred_metrics: [], preferred_projects: projects_list)
@user02 = User.create!(provider_username: "Instructor", uid: "uinstructor", email: 'uinstructor@example.com',
											 provider: "developer", role: User::INSTRUCTOR, password: Devise.friendly_token[0,20],
											 preferred_metrics: [], preferred_projects: projects_list)
@user03 = User.create!(provider_username: "Student", uid: "ustudent", email: 'ustudent@example.com',
											 provider: "developer", role: User::STUDENT, password: Devise.friendly_token[0,20],
											 preferred_metrics: [], preferred_projects: projects_list)
Whitelist.create!(username: @user01.provider_username)
