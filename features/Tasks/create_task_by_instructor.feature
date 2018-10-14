Feature: Staff will be able to create the task graph
  As a course staff of a class
  So that I will be  able to create a default iteration task graph for all the projects under a class
  All the group belong to the projects will be able to see the iteration graph

  Background: A class has several group and the staff is login
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject1 |
    And the following Iteration exist:
      | name         | project_id |
      | TaskCreation | 1          |
    And the "TaskCreation" iteration is map with the following tasks:
      | title               | updater_type     |
      | test task           | testing          |
      | Customer Meeting    | requesting       |
    And I am on the iteration page for "TaskCreation"
    And I will see the three parts of the tasks thread

  Scenario: I will be able to delete task
    Given I should see "Customer Meeting"
    # And I should see "delete" inside "task-Scrum meeting"
    # When I press the "delete" "Scrum meeting"
    #Then  I should not see "Scrum meeting"

  Scenario: I will be able to create task
    #Given I should see "GSI Meeting"
    #When I select "GSI Meeting" inside "title"
    #And I fill in "create task description" with "tasks"
    #And I press the "delete" within "Scrum meeting"
    #Then I should see "GSI Meeting"

  Scenario: I will be able to edit task
    #Given I press "edit task" inside "Customer Meeting"
    #When I fill in "Customer Meeting title" inside "GSI Meeting"
    #And I fill in "Customer Meeting description" with "<param>"
    #And I press the "update" within "Scrum meeting"
    #Then I should see "GSI Meeting"
    #But I should not see "Customer Meeting"

