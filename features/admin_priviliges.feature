Feature: administrators can do everything
In order to administrate
An administrator
Should be the only one able to administrate

  Background:
    Given the "test" user successfully signs up
      And "another" user successfully signs up
    Then the "test" user has the property "is_admin" set to "true"
      And "another" user has the property "is_admin" set to "false"

  Scenario: the admin can't un-admin themself
    When the "test" user toggles the "test" user's admin status
    Then the "test" user has the property "is_admin" set to "true"

  Scenario: the admin can toggle another user's admin status 
    When the "test" user toggles "another" user's admin status
    Then the "another" user has the property "is_admin" set to "true"

  Scenario: the admin can double-toggle admin status
    When the "test" user toggles "another" user's admin status
      And the "test" user toggles "another" user's admin status
    Then "another" user has the property "is_admin" set to "false"

  Scenario: non-admins can't change admin status
    When "another" user toggles "another" user's admin status
      And "another" user toggles the "test" user's admin status
    Then the "another" user has the property "is_admin" set to "false"
      And the "test" user has the property "is_admin" set to "true"

  @creates_db_tables
  Scenario: admins can see other user's stuff
    Given "another" user successfully signed up for a table in the remote database
    When "test" user views "another" user's database table using the api
    Then the response to the api should have code "200"

  @creates_db_tables
  Scenario: non-admins can't see other people's stuff
    Given "test" user successfully signed up for a table in the remote database
    When "another" user views "test" user's database table using the api
    Then the response to the api should have code "401"

  Scenario: a non-admin can see their own stuff
    Given "another" user successfully signed up for a table in the remote database
    When "another" user views "another" user's database table using the api
    Then the response to the api should have code "200"


