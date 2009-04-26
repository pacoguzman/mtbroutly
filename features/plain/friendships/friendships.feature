Feature: Friendships
  In order to I can manage my friendships
  As a registered user
  I want to make friends, follow user, etc...

  Scenario: User can follow othe user
    Given an activated user Fred exists
    And an activated user Aslak exists
    And I login as Fred
    When I visit /
    And I follow "People"
    And I follow "Aslak"
    And I follow "Follow Aslak"
    Then I should see a confirmation
    And I should see a "Fred" as follower