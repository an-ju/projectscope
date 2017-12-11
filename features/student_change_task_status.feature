Feature: student change status of tasks

    As a student
    I want to change status on a specific task
    such that I can show my work progress
  
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
        And I go to iteration dashboard
        And I follow "iteration_1"


    Scenario: students should be able to change status of a parentless task

        Then I should see "customer meeting" with status "In Screen"
        And I should see dropdown menu for "customer meeting"
        When I select "Finished"
        And I press "Save For customer meeting"
        Then I should see "customer meeting" with status "Finished"

    Scenario: students should not be able to change status of task with non-finished parent
 
        And I should see "customer meeting" with status "In Screen"
        And I should see "create low-fi" with status "In Screen"
        And I should not see dropdown menu for "create low-fi"


    Scenario: finish task with parent all completed
       
     
        Then I should see "customer meeting" with status "In Screen"
        And I should see dropdown menu for "customer meeting"
        When I select "Finished" for "customer meeting"
        # And I press "Save For customer meeting"
        Then I should see "customer meeting" with status "Finished"
        And I should see dropdown menu for "create low-fi"
        When I select "Finished" for "create low-fi"
        And I press "Save For create low-fi"
        Then I should see "create low-fi" with status "Finished"


      