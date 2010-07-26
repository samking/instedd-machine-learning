Feature: Create and Delete a remote database using curl
In order to later store data in the database
A client
Should be able to create and delete their own database

@creates_test_db_table
Scenario: Create an account with free username using curl
  Given the test client doesn't have a table in the remote database
  When the test client signs up for a table in the remote database using curl
  Then the test client should have a table in the remote database
    And the response to curl should have code "201" 
    And the body of the response to curl should include "<uid>test</uid>"

@creates_test_db_table
Scenario: Attempt to create an account with used username using curl
  Given the test client successfully signed up for a table in the remote database
  When the test client signs up for a table in the remote database using curl
  Then the response to curl should have code "422" 
    And the body of the response to curl should include "<error>Uid has already been taken</error>"

Scenario: Delete an account in the database using curl
  Given the test client successfully signed up for a table in the remote database
  When the test client deletes the table in the remote database using curl
  Then the response to curl should have code "200"
    And the test client shouldn't have a table in the remote database

Scenario: Attempt to delete an account not in the database using curl
  Given the test client doesn't have a table in the remote database
  When the test client deletes the table in the remote database using curl
  Then the response to curl should have code "404"

