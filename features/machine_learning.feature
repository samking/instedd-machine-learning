Feature: run machine learning on data in the database
In order to learn about the world
A client
Should be able to run machine learning and view the results in the database

Background:
  Given we created a database table named "test_user"
    And we put a "4" row "5" column "small" CSV file at "some_url"
    And we added "some_url" to the "test_user" table

Scenario: attempting to use an unsupported service
  When we run machine learning on "test_user" using the "unsupported" service
  Then we should be told "error"

Scenario: running Calais
  When we run machine learning using the "calais" service
  Then there should be "4" rows in the "test_user" table
    And "4" rows in the "test_user" table should have "6" columns

Scenario: checking on status
  Given no machine learning is running
  When we run machine learning using the "calais" service
  Then no machine learning is running

