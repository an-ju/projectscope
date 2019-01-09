@javascript @omniauth
Feature: add project and its config/credentials info

  As an instructor
  So that I can keep tabs on another project
  I want to add a project and specify credentials for scraping its metrics

  Scenario: add project with config info for CodeClimate gem
    Given I am logged in as admin
    And I am on the new project page
    Then I fill in "project_name" with "Test Project"
    And I enter new "Github" config values:
      | key          | value  |
      | project      | a.com  |
      | access_token | 12345  |
      | main_branch  | master |
    And I enter new "Tracker" config values:
      | key     | value |
      | project | b.com |
      | token   | 5     |
    And I press "Create"
    Then there should be a project "Test Project" with config values:
      | metric_name        | key             | value |
      | pull_requests      | github_project  | a.com |
      | github_use         | github_project  | a.com |
      | point_distribution | tracker_project | b.com |
