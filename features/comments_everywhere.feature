Feature: Students and Instructors can add comments to tasks, general metrics and iterations
  
  As a student or instructor,
  So that I can add information regarding tasks, general metrics and iterations,
  I want to be able to add comments in any of these locations

Background: users and project in the data base
  
  Given the following projects exist:
  | name      |
  | Project_1 |
  | Project_2 |

  Given the following iterations exist:
  | iteration_name |
  | iteration_01   |
  | iteration_11   |
  | iteration_02   |
  | iteration_12   |

Given the following metrics samples exist:
  | metric_name  | project   | score |
  | code_climate | Project_1 | 137   |
  | github       | Project_1 | 3     |
  | code_climate | Project_1 | 200   |

  Given the following tasks exist:
  | title    | iteration_id | task_id | project   |
  | first_1  | iteration_01 | first_1 | Project_1 |
  | second_1 | iteration_01 | first_1 | Project_1 |
  | first_2  | iteration_02 | first_2 | Project_1 |
  | second_2 | iteration_02 | first_2 | Project_1 |

  Given the following users exist:
  | provider_username       | uid         | email                 | provider  | role    | project   |
  | Admin                   | uadmin      | uadmin@example.com    | developer | admin   | Project_1 |
  | Student                 | ustudent    | ustudent@example.com  | developer | student | Project_1 |
  | Student2                | ustudent2   | ustudent2@example.com | developer | student | Project_2 |

Scenario: add admin comment to a general metric
  Given I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the box for general comment with "this is an admin comment on a general metric"
  And I submit general comment form
  And I follow "Project_1"
  And I follow "Code Climate"
  Then I should see "this is an admin comment on a general metric"
  
Scenario: add admin comment to a task
  Given I am "uadmin" and logged in
  And I am on the "edit student task 'first_1'" page
  And I fill in the box for task comment with "this is an admin comment on a task"
  And I submit task comment form
  And I am on the "edit student task 'first_1'" page
  Then I should see "this is an admin comment on a tas"
  
Scenario: add student commment to a task
  Given I am "ustudent" and logged in
  And I am on the "student view task 'first_1'" page
  Then I should see "first_1"
  Then I should see "Add Reply"
  And I fill in the box for task comment with "this is a student comment on a task"
  And I submit task comment form
  And I am on the "student view task 'first_1'" page
  Then I should see "this is a student comment on a task"
  
Scenario: add admin comment to iteration
  Given I am "uadmin" and logged in
  And I am on the "admin task index page for iteration 'iteration_01' and 'Project_1'"
  Then I should see "Add Reply"
  And I fill in the box for iteration comment with "this is a student comment on an iteration"
  And I submit iteration comment form
  And I am on the "admin task index page for iteration 'iteration_01' and 'Project_1'"
  Then I should see "this is a student comment on an iteration"
  
Scenario: add student comment to iteration
  Given I am "ustudent" and logged in
  And I am on the "student task index page for iteration 'iteration_01'"
  Then I should see "Add Reply"
  And I fill in the box for iteration comment with "this is a student comment on an iteration"
  And I submit iteration comment form
  And I am on the "student task index page for iteration 'iteration_01'"
  Then I should see "this is a student comment on an iteration"
  
Scenario: add student commment to a general metric
  Given I am "ustudent" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the box for general comment with "this is an admin comment on a general metric"
  And I submit general comment form
  And I follow "Code Climate"
  Then I should see "this is an admin comment on a general metric"

  