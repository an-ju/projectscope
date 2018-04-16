Feature: Staff will be able to create the task graph
  As a course staff of a class
  So that I will be  able to create a default iteration task graph for all the projects under a class
  All the group belong to the projects will be able to see the iteration graph

  Background: A class has several group and the staff is login
    Given I am logged in
    And the following Iteration exist:
      | name           |
      | IterationGroup |

  Scenario: I will be able to create task
    Given I am on the iteration page for "IterationGroup"
    And I press "create task"
    Then I will see a drop down of task type and update type

  Scenario: I will be able to update task
    Given I am on the iteration page for "IterationGroup"
    And I press "edit task"
    Then I will be able to edit a task select "update type" and "task type"

