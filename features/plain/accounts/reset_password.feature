Feature: Password reset
  In order to sign in even if user forgot their password
  A user
  Should be able to reset it
  
    @improve
    Scenario: User changes his password
      # Lo lógico sería que el usuario no se loguea al cambiar el password y
      # debe hacerlo con el nuevo password
      Given an activated user Fred exists
      When I login as Fred
      When I change my password to "fredpass/newpassword/newpassword"
      Then I should see a confirmation
      Then I should be logged in as Fred
      
    Scenario: User changes his password and types wrong confirmation
      Given an activated user Fred exists
      When I login as Fred
      When I change my password to "fredpass/newpassword/wrongconfirmation"
      Then I should see an error
      And I should be logged in

    Scenario: User changes his password and types wrong his actual password
      Given an activated user Fred exists
      When I login as Fred
      When I change my password to "frednopass/newpassword/wrongconfirmation"
      Then I should see an error
      And I should be logged in

