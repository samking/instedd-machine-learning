Feature: Create and Delete a remote database using web interface or curl
In order to later store data in the database
A client
Should be able to create and delete their own database

#web interface

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

#curl

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

#this scenario doesn't exist for the web interface because there will be 
#no way to view a resource that doesn't exist using the web interface
Scenario: Attempt to delete an account not in the database using curl
  Given the test client doesn't have a table in the remote database
  When the test client deletes the table in the remote database using curl
  Then the response to curl should have code "404"

