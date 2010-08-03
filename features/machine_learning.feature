Feature: run machine learning on data in the database
In order to learn about the world
A client
Should be able to run machine learning and view the results in the database

#backgrounds can't take tags, so each scenario has to have its own 
#@creates_test_db_table tag because this background creates a table
Background:
  Given the test client successfully signed up for a table in the remote database
    And we have a "4row-5col-small.csv" test file
    And the test client adds the "4row-5col-small.csv" file to the database using the api

@creates_test_db_table
Scenario: attempting to use an unsupported service
  When the test client runs machine learning using the "unsupported" service
  Then the response to the api should have code "422"

@creates_test_db_table
Scenario: running Calais
  When the test client runs machine learning using the "calais" service
  Then there should be "4" rows in the test client's table
    And "4" rows in the test client's table should have "6" columns
    And the body of the response to the api should include "calais"

@creates_test_db_table
Scenario: checking on status
  Given the test client has no machine learning running
  When the test client runs machine learning using the "calais" service
  Then the test client has no machine learning running

