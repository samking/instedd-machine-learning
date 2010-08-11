Feature: View a remote database using the api
In order to verify that there is a database table
A client
Should be able to view their own table

##ugly because Webrat Visit doesn't provide a neat interface to specify that you want it to fail
#Scenario: viewing a table that was never created using the api
#  Given the "test" user doesn't have a correct login
#  Then I will fail with a "ActiveRecord::RecordNotFound" exception if I view the "test" user's page
#    And I will fail with a "ActiveRecord::RecordNotFound" exception if the "test" user deletes the table in the remote database using the api

@creates_db_tables
Scenario: viewing an existing table
  Given the "test" user successfully signed up
    And the "test" user successfully signed up for a table in the remote database
  When the "test" user views the "test" user's database table using the api
  Then the response to the api should have code "200"

