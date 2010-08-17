Feature: Create a remote database using the api
In order to later store data in the database
A client
Should be able to create their own database

@creates_db_tables
Scenario: Create an account with free username using the api
  Given the "test" user successfully signs up
  When the "test" user signs up for a table in the remote database using the api
  Then the "test" user should have a table in the remote database
    And the response to the api should have code "201" 
    And the body of the xml response to the api should include an "id" field
    And the body of the xml response to the api should include a "table-uuid" field
    And the body of the xml response to the api should include a "name" field

