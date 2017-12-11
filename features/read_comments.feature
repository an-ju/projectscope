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
  
  Given the following comments exist:
  | user     | content                 | project   | student_task | iteration    | metric_sample | metric        | admin_read | student_read |
  | uadmin   | admin comm sample       | Project_1 | nil          | nil          | 1             | nil           | read       | unread       |
  | ustudent | student comm sample     | Project_1 | nil          | nil          | 1             | nil           | unread     | read         |
  | uadmin   | admin comm s_task       | Project_1 | first_1      | nil          | nil           | nil           | read       | unread       |
  | ustudent | student comm s_task     | Project_1 | first_1      | nil          | nil           | nil           | unread     | read         |
  | uadmin   | admin comm iterat       | Project_1 | nil          | iteration_01 | nil           | nil           | read       | unread       |
  | ustudent | student comm iterat     | Project_1 | nil          | iteration_01 | nil           | nil           | unread     | read         |
  | uadmin   | admin comm g_metric     | Project_1 | nil          | nil          | nil           | code_climate  | read       | unread       |
  | ustudent | student comm g_metric   | Project_1 | nil          | nil          | nil           | code_climate  | unread     | read         |

@javascript
Scenario: student read comment from dashboard
  Given I am "ustudent" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should see "admin comm sample"
  And I should see "admin comm s_task"
  And I should see "admin comm iterat"
  And I should see "admin comm g_metric"

  And I should see "Mark All Read"
  And I Mark All Read for the "sample" comment thread "1"
  And I am on the "student task index page for iteration 'iteration_01'"
  And I am on the "view project 'Project_1'" page
  Then I should not see "admin comm sample"
  And I should see "admin comm g_metric"

  
  And I Mark All Read for the "iteration" comment thread "1"
  And I am on the "student task index page for iteration 'iteration_01'"
  And I am on the "view project 'Project_1'" page
  Then I should not see "admin comm iterat"
  And I should see "admin comm g_metric"

  
  And I Mark All Read for the "task" comment thread "1"
  Then I should not see "admin comm s_task"
  And I am on the "student task index page for iteration 'iteration_01'"
  And I am on the "view project 'Project_1'" page
  Then I should not see "admin comm s_task"
  And I should see "admin comm g_metric"


  And I Mark All Read for the "general_metric" comment thread "1"
  And I am on the "student task index page for iteration 'iteration_01'"
  And I am on the "view project 'Project_1'" page
  Then I should not see "admin comm g_metric"
  
  
Scenario: admin read comment from dashboard
  Given I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should see "student comm sample"
  And I should see "student comm s_task"
  And I should see "student comm iterat"

  And I should see "Mark All Read"  
  
Scenario: student read iteration comment from iteration page
  Given I am "ustudent" and logged in
  And I am on the "student task index page for iteration 'iteration_01'"
  Then I should see "admin comm iterat"
  And I should see "student comm iterat"

  And I should see "Mark All Read"
  
Scenario: admin read iteration comment from iteration page
  Given I am "uadmin" and logged in
  And I am on the "admin task index page for iteration 'iteration_01' and 'Project_1'"
  Then I should see "admin comm iterat"
  And I should see "student comm iterat"

  And I should see "Mark All Read"
  
Scenario: student read task comment from iteration page
  Given I am "ustudent" and logged in
  And I am on the "student view task 'first_1'" page
  Then I should see "admin comm s_task"
  And I should see "student comm s_task"

  And I should see "Mark All Read"
  
Scenario: admin read task comment from iteration page
  Given I am "uadmin" and logged in
  And I am on the "edit student task 'first_1'" page
  Then I should see "admin comm s_task"
  And I should see "student comm s_task"

  And I should see "Mark All Read"
  
@javascript
Scenario: admin notification
  Given I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should have unread indicator
  And I Mark All Read for the "sample" comment thread "1"
  Then I should have unread indicator
  And I Mark All Read for the "general_metric" comment thread "1"
  Then I should have unread indicator
  And I Mark All Read for the "iteration" comment thread "1"
  Then I should have unread indicator
  And I Mark All Read for the "task" comment thread "1"
  Then I should have unread indicator
  And I am on the "view project 'Project_1'" page
  Then I should not have unread indicator
