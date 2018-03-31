Feature: Task will be update thorugh update by event

  As a student
  So that I will have each task map to a list of event
  Task will be automatically updated by event

  Background: The task graph is correctly map to project and iteration keep the correct token to access to event
  Given I am logged in
  And the following projects exist:
  | name         |
  | LocalSupport |
  And the following task graph configs:
  | name             | project      | TaskGraph        | Github        | Pivotal        | Local        |
  | DefaultTaskGraph | LocalSupport | DefaultTaskGraph | DefaultGithub | DefaultPivotal | DefaultLocal |

  Scenario: Task send request and receive callback from event
    Given the "update all" button in task graph page is pressed
    Then access token and all the infomation requested by task graph will be sent seperately through each task
    # consider send graph request as a whole could be a good idea?
    And task graph will receive call back