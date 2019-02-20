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
RawData.delete_all
MetricSample.delete_all
Iteration.delete_all
Task.delete_all

projects_list = []
0.upto(10).each do |num|
  projects_list << Project.create!(name: "Project #{num}")
end

projects_list.each do |project|
  Iteration.create( project_id: project.id,
                    name: 'Iteration 1',
                    start_time: Time.now - 7.days,
                    end_time: Time.now + 7.days)
end

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
  ProjectIssue.create(name: 'test', content: 'This is test 1.', data_version: 1, project: project)
  ProjectIssue.create(name: 'test', content: 'This is test 2.', data_version: 1, project: project)
  ProjectIssue.create(name: 'test', content: 'This is test 3.', data_version: 1, project: project)
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
