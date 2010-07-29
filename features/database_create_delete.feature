Feature: Create and Delete a remote database using the api
In order to later store data in the database
A client
Should be able to create and delete their own database

@creates_test_db_table
Scenario: Create an account with free username using the api
  When the test client signs up for a table in the remote database using the api
  Then the test client should have a table in the remote database
    And the response to the api should have code "201" 
    And the body of the xml response to the api should include an "id" field
    And the body of the xml response to the api should include a "client-uuid" field

Scenario: Delete an account in the database using the api
  Given the test client successfully signed up for a table in the remote database
  When the test client deletes the table in the remote database using the api
  Then the response to the api should have code "200"
    And the test client shouldn't have a table in the remote database

#ugly because Webrat Visit doesn't provide a neat interface to specify that you want it to fail
Scenario: viewing a table that was never created using the api
  Given the test client doesn't have a correct login
  Then I will fail with a "ActiveRecord::RecordNotFound" exception if I view the test client's page
    And I will fail with a "ActiveRecord::RecordNotFound" exception if the test client deletes the table in the remote database using the api

