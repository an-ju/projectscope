Feature:  Task graph will help user to finish the task step by step
  As a students user under a certain project in a certain iteration
  So that I can go through the routes of task graph
  I will be able to finish evert task finally

Background: The default task is generated
  Given that the default task graph is created
  And that I am a student under a project in a iteration

  Scenario: Student will be able to see the task graph
    Then I will be able to see the task graph
    And the task graph will be presented with parent child order

  Scenario: Student will be only be able start their work
    Then I will be able to start my project
    And I will be able to start the unstarted task
    But I won't be able to see the start task button when the status is not unstarted

  Scenario: Student will be able to see the task update when it has status unfinished
    Given that the task A is updated by updater
    Then I will be able to see it's status become finished when I press fresh
    And I will be able to start the next task
