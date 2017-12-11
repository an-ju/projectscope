# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)

    case page_name

      when /^the home\s?page$/
        '/'
      when /^the projects page$/ then
        '/projects'
      when /^the new project page$/ then
        '/projects/new'
      when /^the edit page for project "(.*)"$/ then
        "/projects/#{Project.find_by(name: $1).id}/edit"
      when /^the login page/ then
        '/users/sign_in'
      when /^the whitelist page/ then
        '/whitelists'
      when /^the whitelist management page/ then
        '/whitelists/new'
      when /^team selection page for student "(.*)"/ then
        "/users/#{User.find_by(provider_username: $1).id}/init"
      when /^the dashboard page/ then
        iterations_path
     
      when /^the "create new iteration" page/ then
        edit_iteration_path(1)
      when /^the "iteration dashboard" page/ then
        iterations_path
      when /^the "instructor dashboard" page/ then
        projects_path
      when /^the "edit iteration index (.*)" page/ then
        edit_iteration_path($1)
      when /^the "iteration_(.*) edit" page/ then
        edit_iteration_path($1)
      when /^the "student task index page for iteration '(.*)'"/ then
        team_index_path(Iteration.find_by_name($1).id)
      when /^the "admin task index page for iteration '(.*)' and '(.*)'"/ then
        show_a_team_path(Iteration.find_by_name($1).id, Project.find_by_name($2).id)
      when /^task creation page for "(.*)"/ then
        new_task_view_path(Iteration.find_by_name($1).id)
      when /^the showing "(.*)" page/ then
        show_iteration_path(Iteration.find_by_name($1).id)
      when /^the tasks page for "(.*)" in "(.*)"/ then
        show_a_team_path(:team =>Project.find_by_name($1).id,:iter=>Iteration.find_by_name($2))
      when /^iteration dashboard/ then
        "/iterations"
      when /^the "student page for iteration '(.*)'"/ then
        show_students_task_path(Iteration.find_by_name($1).id)
        
      when /^the "view project '(.*)'" page/ then
        project_path(Project.find_by(name: $1).id)
        
      when /^the "edit student task '(.*)'" page/ then 
        edit_student_task_path(StudentTask.find_by(title: $1).id)
        
      when /^the "student view task '(.*)'"/ then
        detail_history_path(StudentTask.find_by(title: $1).id)

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))
      when /^dashboard for "(.*)"/ then
        edit_iteration_path(Iteration.find_by_name($1).id)
      else
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end
end

World(NavigationHelpers)
