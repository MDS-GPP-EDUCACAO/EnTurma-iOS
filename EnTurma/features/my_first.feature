Feature: Running a test
  As an iOS developer
  I want to have a sample feature file
  So I can begin testing quickly


  Scenario: Example steps
    Given I am on the Welcome Screen
    Given I'm going to report tab
    Then I fill the year field
    And I fill the state field
    And I fill the local field
    And I fill the network field
    And I fill the grade field
    And I generate the report
    Then I swipe left
    And I wait until I don't see "Please swipe left"


