Feature: All iteration properly present the priliminary tasks
  As a student
  So that I will have preliminary tasks
  Tasks will be updated properly

Background: I'm having some existing preliminary graph task
  Given I am logged in
  And the following Iteration exist:
    | name                 |
    | IterationPreliminary |
  And the "IterationPreliminary" iteration is map with the following tasks:
    | title               | updater_type      | task_status |
    | Scrum meeting       | preliminary       | unstarted   |
    | Customer Meeting    | preliminary       | unstarted   |
    | Iteration Planning  | preliminary       | unstarted   |
    | GSI Meeting         | preliminary       | unstarted   |
    | Configuration Setup | preliminary       | unstarted   |

  Scenario: I should see all the preliminary tasks in my task graph page
    Given I am on the iteration page for "IterationPreliminary"
    Then I should see "Preliminary Task"
    And all the preliminary tasks for "IterationPreliminary" are in the preliminary section

  Scenario: the task will be update when the title name is matched and result is true
    Given I receive a "Customer Meeting" with value "true" from event
    Then the "Customer Meeting" task will be able to update

    Given I receive a "Scrum meeting" with value "true" from event
    Then the "Customer Meeting" task will be able to update

    Given I receive a "Iteration Planning" with value "true" from event
    Then the "Customer Meeting" task will be able to update

    Given I receive a "GSI meeting" with value "true" from event
    Then the "Customer Meeting" task will be able to update

    Given I receive a "Configuration setup" with value "true" from event
    Then the "Customer Meeting" task will be able to update
