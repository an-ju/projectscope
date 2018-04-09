Feature: update Task information through Updater from Event

  As a student user who map the project to github and pivotal tracker, google device
  So that I will be to link my task to specific git commit, tracker story, etc
  The related task will be updated once the changed has been mede


  Background: Student has their project map to a certain pivotal tracker, github and google drive
    Given I am logged in
    And the following projects exist:
      | name         |
      | LocalSupport |
    And the following task graph configs:
      | name             | project      | TaskGraph        | Github        | Pivotal        | Local        |
      | DefaultTaskGraph | LocalSupport | DefaultTaskGraph | DefaultGithub | DefaultPivotal | DefaultLocal |

  Scenario: The github task is able to be updated after listening to Event
    Given "Github" default "started" task is mapped to "default branch"
    When "Github" updater receives information of the "default branch" is merge back from Event
    Then I will be able to see the status of the "github branch task" become finished

  Scenario: The pivotal task is being updated after listening to Event
    Given "Pivotal" default "started" task is mapped to "default story"
    When "Pivotal" updater receives information of the "default story" is labeled as finished
    Then I will be able to see the status of the "pivotal story task" become finished

  Scenario: The Local task is being updated after listening to Event
    Given "Local" default "started" task is mapped to "google form"
    When Then "Local" updater receives information of a file is being submited
    Then I will be able to see the status of the "Local google form task" become finished