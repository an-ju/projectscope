
Feature:  Task graph will help user to finish the task step by step

  As a Instructor
  I should be able to modify task graph
  I should be able to understand the progress of student teams from the progress bar

  the color of the progress bar indicates the current status of the team
  green if all tasks are healthy
  red if all current tasks are in danger
  yellow if some tasks are in danger

  Background: The default task is generated
    Given I am logged in
    And the following Iteration exist:
      | name                |
      | IterationInstructor |
    And the "IterationInstructor" iteration is map with the following tasks:
      | title               | updater_type      | task_status |
      | test task           | requesting        | finished    |
      | test task           | requesting        | started     |
      | test task           | planning          | finished    |
      | test task           | planning          | danger      |
      | test task           | planning          | started     |
      | test task           | planning          | started     |
      | test task           | execution         | danger      |
      | test task           | execution         | danger      |

    And I am on the iteration page for "IterationInstructor"

  Scenario: Task progress bar should show the correct percentage for every category
    #Then I should see the progress bar within preliminary tasks
    #And I should see the progress bar within development tasks
    #And I should see the progress bar within post tasks

  Scenario: The percentage should show how many task are finished
    Then I should see the percentage for requesting task should be 50
    And I should see the percentage for planning task should be 25
    And I should see the percentage for execution task should be 20

  Scenario: Student will be able to see the color of the tasks are as required
    #Then I should see the color of preliminary progress bar should be green
    #And I should see the color of preliminary progress bar should be yellow
    #And I should see the color of preliminary progress bar should be red
