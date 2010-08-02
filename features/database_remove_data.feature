Feature: remove data from the database
In order to avoid dealing with large amounts of unnecessary data
A client
Should be able to remove parts of rows or entire rows from their database table

#backgrounds can't take tags, so each scenario has to have its own 
#@creates_test_db_table tag because this background creates a table
Background:
  Given the test client successfully signed up for a table in the remote database
    And we have a "4row-5col-small.csv" test file
    And the test client adds the "4row-5col-small.csv" file to the database using the api

@creates_test_db_table
Scenario: deleting a row
  When we delete a "real" row in the test client's table
  Then there should be "3" rows in the test client's table
    And "3" rows in the test client's table should have "5" columns
    And the row that the test client deleted should not be in the test client's table

@creates_test_db_table
Scenario: deleting a nonexistent row
  When we delete a "fake" row in the test client's table
  Then there should be "4" rows in the test client's table
    And "4" rows in the test client's table should have "5" columns

@creates_test_db_table
Scenario: deleting one column from one row
  When we delete a "real" column from a "real" row in the test client's table
  Then there should be "4" rows in the test client's table
    And "1" row in the test client's table should have "4" columns
    And "3" rows in the test client's table should have "5" columns
    And the element that the test client deleted should not be in the test client's table

@creates_test_db_table
Scenario: deleting a nonexistent columns from a real row
  When we delete a "fake" column from a "real" row in the test client's table
  Then there should be "4" rows in the test client's table
    And "4" rows in the test client's table should have "5" columns

@creates_test_db_table
Scenario: deleting a nonexistent column from a nonexistent row
  When we delete a "fake" column from a "fake" row in the test client's table
  Then there should be "4" rows in the test client's table
    And "4" rows in the test client's table should have "5" columns

