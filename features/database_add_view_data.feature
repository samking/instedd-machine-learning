Feature: add data to a database and view it
In order to run machine learning on the data and view the results of the machine learning
A client
Should be able to add and retrieve data from the database

Background:
  Given the test client successfully signed up for a table in the remote database

#Note: duplicated examples because you can't share them.  See https://rspec.lighthouseapp.com/projects/16211/tickets/348-run-different-scenario-outlines-through-the-same-set-of-examples

#web interface

@creates_test_db_table
Scenario Outline: adding csv file by web interface
  Given we have a "<filename>" file
  When the test client adds the "<filename>" file to the database using the web interface
  Then I should see "Dataset was successfully updated."
    And the contents of the "<filename>" csv file is in the database
    And I should see the contents of the "<filename>" csv file in the database

  Examples: 
    | filename |
    |  4row-5col-small.csv |
    #some columns blank; blank row at the end
    |  4row-5col-missing_elems.csv | 
    #data larger than 1k has to be broken up for sdb
    |  4row-5col-big.csv |  

#api
@creates_test_db_table
Scenario Outline: adding csv file by the api
  Given we have a "<filename>" file
  When the test client adds the "<filename>" file to the database using the api
  Then the response to the api should have code "200"
    And the contents of the "<filename>" csv file is in the database

  Examples: 
    | filename |
    |  4row-5col-small.csv |
    #some columns blank; blank row at the end
    |  4row-5col-missing_elems.csv | 
    #data larger than 1k has to be broken up for sdb
    |  4row-5col-big.csv |  

@creates_test_db_table
Scenario Outline: viewing csv file
  Given the test client successfully added the "<filename>" csv file to the database
  When the test client views their database table using the api
  Then the contents of the "<filename>" csv file is displayed to the api

  Examples: 
    | filename |
    |  4row-5col-small.csv |
    #some columns blank; blank row at the end
    |  4row-5col-missing_elems.csv | 
    #data larger than 1k has to be broken up for sdb
    |  4row-5col-big.csv |  

Scenario: viewing nonexistent file
  Given the test client doesn't have a table in the remote database
  Then I cannot view the test client's page
  When expecting to fail, the test client deletes the table in the remote database using the api
  Then the response to the api should have code "404"

