Feature: add data to a database
In order to run machine learning on the data and view the results of the machine learning
A client
Should be able to add data to the database

Background:
  Given the "test" user successfully signed up
    And the "test" user successfully signed up for a table in the remote database

@creates_db_tables
Scenario Outline: adding csv file by the api
  Given we have a "<filename>" test file
  When the "test" user adds the "<filename>" file to their database table using the api
  Then the response to the api should have code "200"
    And the "test" user has the contents of the "<filename>" csv file in their database table

  Examples: 
    | filename |
    |  4row-5col-small.csv |
    #some columns blank; blank row at the end
    |  4row-5col-missing_elems.csv | 
    #data larger than 1k has to be broken up for sdb
    |  4row-5col-big.csv |  

