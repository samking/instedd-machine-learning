Feature: view data in the database
In order to view the results of the machine learning and verify the integrity of data
A client
Should be able to view data that tehy added to the database

Background:
  Given the "test" user successfully signed up
    And the "test" user successfully signed up for a table in the remote database

@creates_db_tables
Scenario Outline: viewing csv file
  Given the "test" user successfully added the "<filename>" csv file to their database table
  When the "test" user views their database table using the api
  Then the contents of the "<filename>" csv file is displayed to the api
    #TODO: do we also want to test the xml structure of the response?  The above step only tests the content

  Examples: 
    | filename |
    |  4row-5col-small.csv |
    #some columns blank; blank row at the end
    |  4row-5col-missing_elems.csv | 
    #data larger than 1k has to be broken up for sdb
    |  4row-5col-big.csv |  

