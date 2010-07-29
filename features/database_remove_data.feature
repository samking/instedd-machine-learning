Feature: remove data from the database
In order to avoid dealing with large amounts of unnecessary data
A client
Should be able to remove parts of rows or entire rows from their database table

Background:
  Given we created a database table named "test_user"
    And we put a "4" row "5" column "small" CSV file at "some_url"
    And we added "some_url" to the "test_user" table

Scenario: deleting one column from one row
  When we delete a "real" column from a "real" row in the "test_user" table
  Then "1" row in the "test_user" table should have "4" columns
    And "3" rows in the "test_user" table should have "5" columns
    And there should be "4" rows in the "test_user" table

Scenario: deleting a nonexistent columns from a real row
  When we delete a "fake" column from a "real" row in the "test_user" table
  Then there should be "4" rows in the "test_user" table
    And "4" rows in the "test_user" table should have "5" columns

Scenario: deleting a nonexistent column from a nonexistent row
  When we delete a "fake" column from a "fake" row in the "test_user" table
  Then there should be "4" rows in the "test_user" table
    And "4" rows in the "test_user" table should have "5" columns

Scenario: deleting a row
  When we delete a "real" row in the "test_user" table
  Then there should be "3" rows in the "test_user" table
    And "3" rows in the "test_user" table should have "5" columns

Scenario: deleting a nonexistent row
  When we delete a "fake" row in the "test_user" table
  Then there should be "4" rows in the "test_user" table
    And "4" rows in the "test_user" table should have "5" columns

