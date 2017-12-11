Feature: publish tasks to all the teams and edit for each team

  As an instructor
  I want to edit tasks for each team.
  So every time can have customized tasks.
  
  Background: I am on the instructor-dashboard page
    Given Create team "team1"
    Given Create team "team2"
    Given I am logged in
    And I have "iteration_1" iterations created
    And I am on the "iteration dashboard" page
    And I follow "iteration_1"
    Given I create Task "customer meeting" to "meet with customer"
    And I follow "Edit Iteration"
    When I follow "Add new task"
    And I fill in "task_title" with "create low-fi"
    And I fill in "task_description" with "mock up after the meeting"
    And I should see "customer meeting"
    And I check "tasks[customer meeting]"
    And I press "Create Task"
    
 

 
  
    Scenario: publish task to students and see team's general graph
        Then I follow "Publish tasks"
        And I am on the showing "iteration_1" page
        Then I should see graph for "team1"
        Then I should see graph for "team2"
        
    Scenario: each team's graph can be clicked for edit
        Then I follow "Publish tasks"
        And I am on the showing "iteration_1" page
        Then I should see graph for "team1"
        Then I should see graph for "team2"
        Then I follow "team1"
        Then I should be on the tasks page for "team1" in "iteration_1"
    Scenario: add new tasks to team's graph
        Then I follow "Publish tasks"
        And I am on the showing "iteration_1" page
        Then I should see graph for "team1"
        Then I should see graph for "team2"
        Then I follow "team1"
        Then I follow "Add new task"
         And I fill in "task_title" with "third task"
        And I fill in "task_description" with "baah"
        And I should see "customer meeting"
        And I check "tasks[customer meeting]"
        And I press "Save"
        And I should see "third task"
     Scenario: delete task for a team
        Then I follow "Publish tasks"
        And I am on the showing "iteration_1" page
        Then I should see graph for "team1"
        Then I should see graph for "team2"
        Then I follow "team1"
        Then I follow "customer meeting"
        Then I press "Delete Task"
        And I should not see "customer meeting"
        
    Scenario: edit for individual team's tasks
        Then I follow "Publish tasks"
        And I am on the showing "iteration_1" page
        Then I should see graph for "team1"
        Then I should see graph for "team2"
        Then I follow "team1"
        Then I should be on the tasks page for "team1" in "iteration_1"
        Then I should see the "create low-fi" link
        Then I edit "create low-fi"
        And I fill in "task_title" with "create high-fi"
        And I fill in "task_description" with "work with the customer"
        Then I press "Save Edit"
        Then I should be on the tasks page for "team1" in "iteration_1"
        Then I should see "Successfully saved the change"
        Then I should see "create high-fi"
        Then I should not see "create low-fi"
  