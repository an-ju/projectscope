Feature: Staff will be able to create the task graph
  As a course staff of a class
  So that I will be  able to create a default iteration task graph for all the projects under a class
  All the group belong to the projects will be able to see the iteration graph

  Background: A class has several group and the staff is login
    Given I am logged in
    And there exists three projects

  Scenario: I will be able to create task
    Given when I go to the page for "default iteration"
    When I press the "create task" button
    Then I will see a form contain drop down of task type and update type
    And I will select "local submit task" from "update type"
    And I will select a "customer meeting" from the "task type"
    And I can create a task after press "create task" button
    #todo

  Scenario: I will be able to update task
    Given when I go to the page for "default iteration"
    When I press the "edit task" button for "default task"
    Then I will be able to edit a task select "update type" and "task type"

