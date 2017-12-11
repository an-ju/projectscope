Feature: add and edit tasks to exisiting iteration

  As an instructor
  I want to add different tasks to an iteration and order the tasks
  So that students will know what they need to do in the iteration.
  
  Background: I am on the instructor-dashboard page
    Given I am logged in
    And I have "iteration_1" iterations created
    And I am on the "iteration dashboard" page
    # And I am on the dashboard page
    And I follow "iteration_1"
    And I follow "Edit Iteration"
    # Then I should be on the "iteration_1 edit" page

  Scenario: Instructor should see a link to add task
    Then I should see the "Add new task" link
	 # Then I should see a link to "Add new task"

  Scenario: Instructor can create a task
    
    Then I follow "Add new task"
    Then I should be on task creation page for "iteration_1"
    
  Scenario: Instructor create a new task for the first time
    When I follow "Add new task"
    And I fill in "task_title" with "todo1"
    And I fill in "task_description" with "first todo"
    And I press "Create Task"
    Then I should be on dashboard for "iteration_1"
    And I should see "Successfully created task"
    And I should see "first todo"

  Scenario: task creation must specify task title
    When I follow "Add new task"
    And I fill in "task_description" with "first todo"
    And I press "Create Task"
    Then I should see "Please fill in all required fields"
    And I should not see "Successfully created task"
    And I should be on task creation page for "iteration_1"

  Scenario: task creation must specify task description
    When I follow "Add new task"
    And I fill in "task_title" with "todo1"
    And I press "Create Task"
    Then I should see "Please fill in all required fields"
    And I should not see "Successfully created task"
    And I should be on task creation page for "iteration_1"
  
  Scenario: add more task for a iteration
    Given I create Task "customer meeting" to "meet with customer"
    When I follow "Add new task"
    And I fill in "task_title" with "create low-fi"
    And I fill in "task_description" with "mock up after the meeting"
    And I should see "customer meeting"
    And I check "tasks[customer meeting]"
    And I press "Create Task"
    Then I should see "Successfully created task"
    And I should see "customer meeting"
    
  Scenario: edit existing task
    Given I create Task "customer meeting" to "meet with customer"
    And I am on the "iteration dashboard" page
    # And I am on the dashboard page
    And I follow "iteration_1"
    And I follow "Edit Iteration"
    When I follow "customer meeting"
    # When I select "customer meeting" and press edit
    And I fill in "task_title" with "first official meeting"
    And I fill in "task_description" with "Meeting customer for first time and learn their need"
    And I press "Save Edit"
    Then I should see "Successfully saved the changes"
    Then I follow "Edit Iteration"
    And I should see "first official meeting"
    And I should not see "customer meeting"


  Scenario: copy tasks button available
    Given I create Task "todo1" to "todo in iter1"
 
    And I have "iteration_2" iterations created
    And I am on the "iteration dashboard" page
    And I follow "iteration_2"
    And I follow "Edit Iteration"
    Then I should see "Copy tasks to"
   
    

  Scenario: copy tasks from existing iteration
    Given I create Task "todo1" to "todo in iter1"
  
    And I have "iteration_2" iterations created
    And I am on the "iteration dashboard" page
    And I follow "iteration_2"
    And I follow "Edit Iteration"
    Then I check "iterations[1]" 
    Then I press "Copy"
    Then I should see "todo1"
Scenario: delete existing task
    Given I create Task "customer meeting" to "meet with customer"
    And I am on the "iteration dashboard" page
    # And I am on the dashboard page
    And I follow "iteration_1"
    And I follow "Edit Iteration"
    When I follow "customer meeting"
    And I fill in "task_description" with "Meeting customer for first time and learn their need"
    And I press "Save Edit"
    Then I follow "Edit Iteration"
    And I follow "customer meeting"
    And I press "Delete Task"
    And I should not see "customer meeting"