Feature: remove data from the database
In order to avoid dealing with large amounts of unnecessary data
A client
Should be able to remove parts of rows or entire rows from their database table

#backgrounds can't take tags, so each scenario has to have its own 
#@creates_db_tables tag because this background creates a table
Background:
  Given the "test" user successfully signed up
    And the "test" user successfully signed up for a table in the remote database
    And we have a "4row-5col-small.csv" test file
    And the "test" user adds the "4row-5col-small.csv" file to their database table using the api

@creates_db_tables
Scenario: deleting a row
  When the "test" user deletes a "real" row in the "test" user's table
  Then there should be "3" rows in the "test" user's table
    And "3" rows in the "test" user's table should have "5" columns
    And the row that the "test" user deleted should not be in the "test" user's table

@creates_db_tables
Scenario: deleting a nonexistent row
  When the "test" user deletes a "fake" row in the "test" user's table
  Then there should be "4" rows in the "test" user's table
    And "4" rows in the "test" user's table should have "5" columns

@creates_db_tables
Scenario: deleting one column from one row
  When the "test" user deletes a "real" column from a "real" row in the "test" user's table
  Then there should be "4" rows in the "test" user's table
    And "1" row in the "test" user's table should have "4" columns
    And "3" rows in the "test" user's table should have "5" columns
    And the element that the "test" user deleted should not be in the "test" user's table

@creates_db_tables
Scenario: deleting a nonexistent columns from a real row
  When the "test" user deletes a "fake" column from a "real" row in the "test" user's table
  Then there should be "4" rows in the "test" user's table
    And "4" rows in the "test" user's table should have "5" columns

@creates_db_tables
Scenario: deleting a nonexistent column from a nonexistent row
  When the "test" user deletes a "fake" column from a "fake" row in the "test" user's table
  Then there should be "4" rows in the "test" user's table
    And "4" rows in the "test" user's table should have "5" columns

