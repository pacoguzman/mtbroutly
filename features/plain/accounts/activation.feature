Feature: Activating an account
  In order to I can log in to the site
  As a registered, but not yet activated, user
  I want to be able to activate my account

  Scenario: Registered user can activate her account    
     Given I am a registered user
     When I activate myself
     Then I should see a confirmation
     And I should be activated

  Scenario: Registered user cannot activate her account without an activation code
     #No se genera una ruta y no se encuentra sino lleva asociada un código de activación
     Given I am a registered user
     When I activate myself without an activation code
     Then I should see an error
     And I should not be activated

   Scenario: Registered user cannot activate her account with a bogus activation code    
     Given I am a registered user
     When I activate myself with a bogus activation code
     Then I should see an error
     And I should not be activated