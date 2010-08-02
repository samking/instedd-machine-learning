Feature: add data to a database
In order to run machine learning on the data and view the results of the machine learning
A client
Should be able to add data to the database

Background:
  Given the test client successfully signed up for a table in the remote database

#api
@creates_test_db_table
Scenario Outline: adding csv file by the api
  Given we have a "<filename>" test file
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

