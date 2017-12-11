Given(/^I am under "([^"]*)"$/) do |page|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see a link to "([^"]*)"$/) do |web|
  steps %Q{ I should see the "#{web}" link}
   # Write code here that turns the phrase above into concrete actions
end

Then(/^I should be redirect to dashboard page$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^I should see "([^"]*)" under "([^"]*)"$/) do |content, tag|
  pending # Write code here that turns the phrase above into concrete actions
end


Given(/^I check "([^"]*)" as parents$/) do |parent_task|
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I select "([^"]*)" and press edit$/) do |task|
  steps %Q{ 
    Given I follow "#{task}"
    # Then I press "Edit"
  }
  # pending # Write code here that turns the phrase above into concrete actions
end

Given (/^I create Task "([^"]*)" to "([^"]*)"$/) do |title, description|
  iter = Iteration.find_by_name("iteration_1")
  t1 = Task.new
  t1.iteration=iter
  t1.title=title
  t1.description=description
  t1.save
  # pending
end
Given("I go back to iteration dashboard") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I select {string} to copy") do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("Create team {string}") do |string|
  n = Project.new
  n.name= string
  n.save
   # Write code here that turns the phrase above into concrete actions
end

Then("I should see graph for {string}") do |string|
   steps %Q{Then I should see the "#{string}" link}
   # Write code here that turns the phrase above into concrete actions
end



Then("I edit {string}") do |string|
   steps %Q{Then I follow "#{string}"
   }
  # Write code here that turns the phrase above into concrete actions
end
Given("I am logged in again") do
  admin_user = User.where( :email =>'uadmin@example.com')[0]
  
  ENV['ADMIN_PASSWORD'] = 'password'
  visit "/login/#{admin_user.uid}?passwd=password"
  # pending # Write code here that turns the phrase above into concrete actions
end

Given("I view history for {string}") do |string|
  click_link(string+"history")
  # pending # Write code here that turns the phrase above into concrete actions
end

Given("I am logged in as {string} again") do |string|
  ENV['ADMIN_PASSWORD'] = 'password'
  project_id = Project.find_by_name(string).id
  admin_user = User.where(:project_id =>project_id)[0]
  if admin_user == nil
    admin_user = User.create!(provider_username: "Admin_stu", uid: "uadmin_stu", email: 'uadmin_stu@example.com',
                            provider: "developer", role: User::STUDENT, password: Devise.friendly_token[0,20])

    admin_user.project_id = project_id
    admin_user.save
  end
  visit "/login/#{admin_user.uid}?passwd=password"

end

Given("I am logged in as {string}") do |string|
  admin_user = User.create!(provider_username: "Admin_stu", uid: "uadmin_stu", email: 'uadmin_stu@example.com',
                            provider: "developer", role: User::STUDENT, password: Devise.friendly_token[0,20])
  ENV['ADMIN_PASSWORD'] = 'password'
  puts "log in"
  puts admin_user.role
  admin_user.project_id = Project.find_by_name(string).id
  admin_user.save
  visit "/login/#{admin_user.uid}?passwd=password"
   # Write code here that turns the phrase above into concrete actions
end

Given("I select {string}") do |string|
  steps %Q{ I follow "#{string}"}
  # pending # Write code here that turns the phrase above into concrete actions
  
end


Then(/^I should see "([^"]*)" with status "([^"]*)"$/) do |tasktitle, status|
   steps %Q{ 
    Then I should see "#{status}"
    }
end


Given("I should see dropdown menu for {string}") do |string|
   steps %Q{ 
    Then I should see the "Save For #{string}" button
    }
   # Write code here that turns the phrase above into concrete actions
end


# When("I select {status} for {task}") do |status, task|
  
#     # select(status,:from=>task+'status')

# end

Given("I finish task {string}") do |string|
  # find('#status').select("Finished")
  steps %Q{ 
    Then I select "Finished" for "#{string}"}
   # Write code here that turns the phrase above into concrete actions
end
Given ( "I should not see dropdown menu for {string}") do|string|
  # select_box = find()
  expect(page).not_to have_selector("#form:"+string)
  # expect("#form:"+string).not_to be_present
end
When("I select {string} for {string}") do |string, string2|
  # pending # Write code here that turns the phrase above into concrete actions
  select(string,:from=>string2+'status')
  steps %Q{ 
    Then I press "Save For #{string2}"}
end
# And (/^I  am on Iteration "([^"]*)"$/) do |iter|
#   steps %Q{
#     And I have "iteration_1, iteration_2" iterations created
#     And I am on the "iteration dashboard" page
#     Then I should see the "iteration_1" link
#     When I follow "iteration_1"
#   }
# end