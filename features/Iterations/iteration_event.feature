Feature: Started tasks will be send and receive update info in iteration package with event

  As a student
  So that I will have each task map to a list of event
  Task will be automatically updated by event

  Background: The task graph is correctly map to project and iteration keep the correct token to access to event
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject2 |
    And the following Iterations exist start "2022/4/1" end "2023/2/4":
      | name           | project_id |
      | IterationEvent | 1          |
    And the "IterationEvent" iteration is map with the following tasks:
      | title       | updater_type |
      | test task   | testing      |
      | test task   | testing      |
      | test task   | testing      |
    Given I am on the iteration page for "IterationEvent"

  Scenario: Iteration send request and receive callback from event of all new events
    # And I press "update all"
    Then Tasks will be updated if they reach the requirement to update

  Scenario: I cannot delete or create task
    Then I cannot create task
    And I cannot edit task
    And I cannot delete task