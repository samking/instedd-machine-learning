Feature: Delete a remote database using the api
In order to clean up unnecessary data from the database
A client
Should be able to delete their own database

Scenario: Delete an account in the database using the api
  Given the "test" user successfully signed up
    And the "test" user successfully signed up for a table in the remote database
  When the "test" user deletes their table in the remote database using the api
  Then the response to the api should have code "200"
    And the "test" user shouldn't have a table in the remote database
