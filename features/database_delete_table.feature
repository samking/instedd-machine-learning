Feature: Delete a remote database using the api
In order to clean up unnecessary data from the database
A client
Should be able to delete their own database

Scenario: Delete an account in the database using the api
  Given the test client successfully signed up for a table in the remote database
  When the test client deletes the table in the remote database using the api
  Then the response to the api should have code "200"
    And the test client shouldn't have a table in the remote database
