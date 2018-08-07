Feature: Tasks will show in timeline
  As an intructor
  I will be able to modify the tasks timeline
  as an student
  I will be able to see my progress and follow instruction

  Background: There exists an iteration belong to a certain project
    Given I am logged in
    And the following Iterations exist start "2022/4/1" end "2023/2/4":
      | name         |
      | TimelineIter |
    And the "TimelineIter" iteration is map with the following tasks:
      | title               | updater_type     | task_status | duration |
      | Scrum meeting       | preliminary      | started     | 4        |
      | Customer Meeting    | preliminary      | started     |          |
      | TDD and BDD         | development      | started     | 2        |
      | Points Estimation   | development      | started     | 2        |
    And I am on the iteration page for "TimelineIter"

  Scenario: I will see the iteration's timeline show the correct deadline
    Then I should see "4 April , Monday 2022"
    And I should see "6 April , Wednesday 2022"
    And I should see "8 April , Friday 2022"
