Feature: Instructor will be able to assign iteration by assigning iteration graph
  As an instructor
  I should be able to select which template to assign to project
  so that they will have new project for the new iteration

  Background: There exists two projects and I login as instructor
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject1 |
      | TestProject2 |
    And the following Iteration exist:
      | name          |
      | TempIteration |
    And I am on the iterations page
    
  Scenario: Select all from the the tasks graph
    Given I select "TempIteration" from "apply_all"
    Then I press "Apply to all"
    #Then All the projects should have status "assigned"
    #And All projects will have current iteration same as "TempIteration"

  Scenario: I can assign project with existing tasks graph template
    #Given I select test task graph from the select box in "TestProject1" Selectbox
    #And I click "apply" in "TestProject1" button
    #Then "TestProject1" will have a current task graph same as "test task graph"

  Scenario: I can assign template to projects that have unassigned status
    #Given that a project is unassigned
    #Then I can assign new template
    #Then the status will become assgined
    #And I cannot assign template
