Feature: Started tasks will be send and receive update info in iteration package with event

  As a student
  So that I will have each task map to one or more event
  Task will be automatically updated when iteration pull new event

  Background: The task graph is correctly map to project and iteration keep the correct token to access to event
    Given I am logged in
    And the following projects exist:
    | name         |
    | LocalSupport |
    And the following project configs:
    | name             | project      | TaskGraph        | Github        | Pivotal        | Local        |
    | DefaultTaskGraph | LocalSupport | DefaultTaskGraph | DefaultGithub | DefaultPivotal | DefaultLocal |

  Scenario: All types of tasks will have different key which will let the update event recognize them
    Given that I created a "update key task" that with "started" status
    Then I will be able to add "update key" and update info to "update key task"

  Scenario: Task will handle the call back respectively after iteration receive callback
    Given task graph receives call back after "update all" button is pressed
    Then all the "started" tasks will call their updater to see if they reach the requirement for update
    Then they will update all that reach the requirement
