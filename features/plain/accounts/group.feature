Feature: Gestión de grupos
  In Order to los usuarios esten contentos y puedan gestionar grupos
  As miembro de la aplicación
  I want to poder realizar operaciones sobre grupos

  @focus
  Scenario: Creación de un nuevo grupo
    Given an activated user Fred exists
    When I login as Fred
    When I create a group with "Developers/Grupo de desarrolladores de la aplicación/developers,dev,init"
    Then I should see a confirmation
    Then I should see "Developers"
    Then I should see "Grupo de desarrolladores de la aplicación"
    Then I should see "developers"
    Then I should see "dev"
    Then I should see "init"

  @pending
  Scenario: Editar los datos de un grupo ya completado