Feature: 
  As user
  I want to view graphs about the class
  So that I can analyse this class

  Scenario: Graphs Generated
    Given I am on the Welcome Screen
    Given I'm going to report tab
    Then I fill the form fields
    Then I generate the report
    And I see all graph


