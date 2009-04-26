Feature: Manage configuration
  In order to an admin manage the app configuration
  As a admin user
  I want to manage the configuration

  @pending
  Scenario Outline: Update configuration aspects
    Given an admin user Fred exists
    When I visit /admin
    And I fill in field named <field> with <content>
    And I press "Update configuration"
    Then the field named <field> should contain <content>

  Examples:
    |                  field                  | content |
    | "config_plugins.tog_user.email_as_login" |  "true"   |