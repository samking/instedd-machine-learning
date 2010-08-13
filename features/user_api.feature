Feature: make interface for users available over the api
In order to avoid the web interface
A client
Should be able to create, delete, and manage their account over the API

#This assumes that accounts feature did rigorous testing on validations and 
#general user stuff.  This just makes sure that the API works.

  Scenario: Anonymous user can create an account over the API
    Given no "test" user exists
    When the "test" user signs up using the api
    Then the "test" user exists
      And the response to the api should have code "200"

  Scenario: Delete an account over the API
    Given the "test" user successfully signs up
    When the "test" user deletes their account
    Then no "test" user exists
      And the response to the api should have code "200"

