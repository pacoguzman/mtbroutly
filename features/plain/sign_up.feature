Feature: Sign up
  In order to get access to protected sections of the site
  A user
  Should be able to sign up

    @moved
    Scenario: User signs up with invalid data
      When I go to the signup page
      And I fill in "Login" with "login"
      And I fill in "Email" with "invalidemail"
      And I fill in "Password" with "password"
      And I fill in "Repeat password" with "password"
      And I press "Sign Up"
      Then I should see error messages

    @moved
    Scenario: User signs up with valid data
      When I go to the signup page
      And I fill in "Login" with "login"
      And I fill in "Email" with "email@person.com"
      And I fill in "Password" with "password"
      And I fill in "Repeat password" with "password"
      And I press "Sign Up"
      Then I should see "instructions for confirming"
      And a confirmation message should be sent to "email@person.com"

    @moved
    Scenario: User confirms his account
      Given an registered user exists as "login/email@person.com/password"
      When I follow the confirmation link sent to "email@person.com"
      Then I should see "Confirmed email and signed in"
      And I should be signed in      
      
      
      
