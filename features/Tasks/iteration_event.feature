Feature: Started tasks will be send and receive update info in iteration package with event

  As a student
  So that I will have each task map to a list of event
  Task will be automatically updated by event

  Background: The task graph is correctly map to project and iteration keep the correct token to access to event
    Given I am logged in
    And the following projects exist:
      | name         |
      | LocalSupport |
    And the following project configs:
      | name             | project      | TaskGraph        | Github        | Pivotal        | Local        |
      | DefaultTaskGraph | LocalSupport | DefaultTaskGraph | DefaultGithub | DefaultPivotal | DefaultLocal |

  Scenario: Iteration send request and receive callback from event of all new events
    Given the "update all" button in task graph page is pressed
    Then access token and time stamp will be sent
    And iteration should receive call back which contains all the new event since last request