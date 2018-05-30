Feature: Instructor create template

  As an instructor
  So that I will be able to create my own template
  I can assign project with template as their new tasks graph

  Background: There exists two projects and I login as instructor
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject1 |
      | TestProject2 |
    And I am on the iteration template page

  Feature: I will be able to create template
    When I write "template 1" into
    Then I press "create template"
    Then I will have a new template "template 1"

