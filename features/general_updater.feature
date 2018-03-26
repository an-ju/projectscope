Feature: update Task infomation through Updater from Event
  As a student user who map the project to github and pivotal tracker, google device
  So that I will be to link my task to specific git commit, tracker story, etc
  The related task will be updated once the changed has been mede


  Background: Student has their project map to a certain pivotal tracker, github and google drive
    Given a student under a group
    And my project is mapped to a pivotal tracker, github
    And I'm under default iteration

  Scenario: The github task is being updated after Event pull infomation
    When Event updated
    Then I will be able to update the status by freshing page


