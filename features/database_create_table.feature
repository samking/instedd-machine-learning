Feature: Create a remote database using the api
In order to later store data in the database
A client
Should be able to create their own database

@creates_test_db_table
Scenario: Create an account with free username using the api
  When the test client signs up for a table in the remote database using the api
  Then the test client should have a table in the remote database
    And the response to the api should have code "201" 
    And the body of the xml response to the api should include an "id" field
    And the body of the xml response to the api should include a "client-uuid" field

