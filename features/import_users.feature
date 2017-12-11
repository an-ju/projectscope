Feature:import users from excel file

    As a instructor
    I want to import some users from a xlsx file
  
    Background: I am on the team-dashboard page
        Given I am logged in
    Scenario: I see a link to import
      And I should see the "Import User" link
    Scenario: I can upload the file
      And I follow "Import User"
      And I upload users file
    Scenario: I can import the file
      And I follow "Import User"
      And I upload users file
      And I press "Import"
      
