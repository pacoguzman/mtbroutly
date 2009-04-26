Feature: Gestión del perfil del usuario
  In order to los usuarios esten contentos
  As a miembro de la aplciación
  I want poder realizar operaciones sobre mi perfil

  Scenario: Completar los datos del perfil
    Given an activated user Fred exists
    When I login as Fred
    When I edit my profile to "Paco/Guzmán/http://www.ridingtonowhere.com"
    Then I should see a confirmation
    Then I should see "Paco"
    Then I should see "Guzmán"
    Then I should see "www.ridingtonowhere.com"

  @pending
  Scenario: Editar los datos de un perfil ya completado