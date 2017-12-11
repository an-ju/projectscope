Feature: student can view tasks for each iteration

  As a student
  I want to see the tasks assigned to us for each iteration
  
  Background: I am on the team-dashboard page
    Given Create team "team1"
    Given I am logged in
    And I have "iteration_1" iterations created
    And I am on the "iteration dashboard" page
    And I follow "iteration_1"
    And I follow "Edit Iteration"
    Given I create Task "customer meeting" to "meet with customer"
    When I follow "Add new task"
    And I fill in "task_title" with "create low-fi"
    And I fill in "task_description" with "mock up after the meeting"
    And I should see "customer meeting"
    And I check "tasks[customer meeting]"
    And I press "Create Task"
    And I follow "Publish tasks"
    And I follow "Logout"
    Given I am logged in as "team1"
 

 
  
    Scenario: should be able to select iteration
      And I should see "Iterations"
      And I follow "Iterations"
      And I should see the "iteration_1" link

      
     Scenario: should be able to view tasks iteration
      And I go to iteration dashboard
      And I should see "iteration_1"
      And I follow "iteration_1"
      Then I should see "customer meeting"
  
      
  
