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

  # examples of Event are listened by different updater
  Scenario: The github task is able to be updated after listening to Event
    Given "Github" default "unfinished" task is mapped to default branch
    When "Github" updater receives information of the default branch is merge back from Event
    Then I will be able to see the the status of the "Github" default "unfinished" task become finished

  Scenario: The pivotal task is being updated after listening to Event
    Given "Pivotal" default "unfinished" task is mapped to default branch
    When Then "Github" updater receives information of a certain story is labeled as finished
    Then I will be able to see the the status of the "Pivotal" default "unfinished" task become finished

  Scenario: The Local task is being updated after listening to Event
    Given "Local" default "unfinished" task is mapped to default branch
    When Then "Local" updater receives information of a file is being submited
    Then I will be able to see the the status of the "Local" default "unfinished" task become finished