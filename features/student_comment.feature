Feature: students can comment 

  As an student, 
  So that I can pass context about metrics to Instructors and teammates
  I want to be able to add comments (new comment threads) to metrics
  
Background: users and project in the data base
  
  Given the following projects exist:
  | name      |
  | Project_1 |
  | Project_2 |

  Given the following metrics samples exist:
  | metric_name  | project   | score |
  | code_climate | Project_1 | 137   |
  | github       | Project_1 | 3     |
  | code_climate | Project_1 | 200   |

  Given the following users exist:
  | provider_username       | uid         | email                 | provider  | role    | project   |
  | Admin                   | uadmin      | uadmin@example.com    | developer | admin   | Project_1 |
  | Student                 | ustudent    | ustudent@example.com  | developer | student | Project_1 |
  | Student2                | ustudent2   | ustudent2@example.com | developer | student | Project_2 |

Scenario: add new comment as admin
  Given I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the "1st" comment box with "this is an admin comment"
  And I submit form number "1"
  And I follow "Project_1"
  Then I should not see "this is an admin comment"
  And I am "ustudent" and logged in
  Then I should see "this is an admin comment"

Scenario: add new comment as student
  Given I am "ustudent" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the "1st" comment box with "this is a student comment"
  And I submit form number "1"
  Then I should not see "this is a student comment"
  And I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should see "this is a student comment"
  
Scenario: can't add comment if student of different project
  Given I am "ustudent2" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  Then I should not see "Add Reply"
  
Scenario: see reply to metric comment as student
  Given I am "ustudent" and logged in
  And there is a "uadmin" comment "ad com" on project "Project_1" metric "code_climate"
  And I am on the "view project 'Project_1'" page
  Then I should see "Reply"
  
Scenario: I see name attached to comment in metric page and project page
  Given there is a "uadmin" comment "another ad com" on project "Project_1" metric "code_climate"
  And I am "ustudent" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should see "Admin"
  And I follow "Code Climate"
  Then I should see "Admin"
  
Scenario: name should appear next to comment
  Given I am "ustudent" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the "1st" comment box with "this is a student comment"
  And I submit form number "1"
  Then I should not see "Student: this is a student comment"
  And I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  Then I should see "Student: this is a student comment"

Scenario: reply to a comment as a student, :js => true
  Given I am "ustudent" and logged in
  And there is a "uadmin" comment "ad com" on project "Project_1" metric "code_climate"
  And I am on the "view project 'Project_1'" page
  Then I should see "ad com"
  And I should see "Reply"
  And I fill in the "3rd" comment box with "this is a student reply"
  And I press "Reply"
  Then I should see "ad com"
  And I should see "this is a student reply"

  
Scenario: writing comment associates with correct metric sample
  Given I am "uadmin" and logged in
  And I am on the "view project 'Project_1'" page
  And I follow "Code Climate"
  And I fill in the "1st" comment box with "this should be on second metric"
  And I submit form number "1"
  And I follow "Project_1"
  And I am "ustudent" and logged in
  Then there should be metric "0"
  And there should not be metric "2"

