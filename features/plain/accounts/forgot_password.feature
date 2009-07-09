Feature: Forgot Password
  In order to recover her password to login in the site
  A user
  Should be able to recover his password

    Scenario: User ask for his password
      Given an activated user Fred exists
      And I am logged out
      When I surf to forgot password
      And I fill in "Your email address" with "Fred@example.com"
      And I press "Send"
      Then I should see a confirmation
      And debe haberse enviado un correo a esa dirección de correo

    Scenario: User ask for her password with invalid email
      Given an activated user Fred exists
      And I am logged out
      When I surf to forgot password
      And I fill in "Your email address" with "Freddy@example.com"
      And I press "Send"
      Then I should see an error

