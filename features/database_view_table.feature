Feature: View a remote database using the api
In order to verify that there is a database table
A client
Should be able to view their own table

#ugly because Webrat Visit doesn't provide a neat interface to specify that you want it to fail
Scenario: viewing a table that was never created using the api
  Given the test client doesn't have a correct login
  Then I will fail with a "ActiveRecord::RecordNotFound" exception if I view the test client's page
    And I will fail with a "ActiveRecord::RecordNotFound" exception if the test client deletes the table in the remote database using the api

@creates_test_db_table
Scenario: viewing an existing table
  Given the test client signs up for a table in the remote database using the api
  When I view the test client's page using the api
  Then the response to the api should have code "200"

