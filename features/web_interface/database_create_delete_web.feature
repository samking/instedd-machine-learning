Feature: Create and Delete a remote database using the web interface
In order to test the database
A client
Should be able to create and delete their own database

@creates_test_db_table
Scenario: Create an account with free username using web interface
  Given the test client doesn't have a table in the remote database
  When the test client signs up for a table in the remote database using the web interface
  Then the test client should have a table in the remote database
    And I should see "Dataset was successfully created"

@creates_test_db_table
Scenario: Attempt to create an account with used username using web interface
  Given the test client successfully signed up for a table in the remote database
  When the test client signs up for a table in the remote database using the web interface
  Then I should see "Uid has already been taken"

Scenario: Delete an account in the database using web interface
  Given the test client successfully signed up for a table in the remote database
  When the test client deletes the table in the remote database using the web interface
  Then I should see "Dataset was successfully deleted"
    And the test client shouldn't have a table in the remote database


