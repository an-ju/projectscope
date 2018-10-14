Feature: All iteration properly present the development tasks
  As a student
  So that I will have preliminary tasks
  Tasks will be updated properly

  Background: I'm having some existing preliminary graph task
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject  |
    And the following Iteration exist:
      | name                 | project_id |
      | IterationDevelopment | 1          |
    And the "IterationDevelopment" iteration is map with the following tasks:
      | title              | updater_type |
      | test task          | testing      |
      | Customer Meeting   | requesting   |
    Given I am on the iteration page for "IterationDevelopment"


  Scenario: I should see all the preliminary tasks in my task graph page
    Then I should see "Request"
    And I should not see "test task"

  Scenario: the task will be update when the title name is matched and result is true
    Given I receive a "Customer Meeting" with value "true" from event
    Then the "Customer Meeting" task have a finished status