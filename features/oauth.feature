Feature: acting as an OAuth provider
In order to give consumers (external clients) the authority to use data without exposing credentials
A client
Should be able to gain OAuth credentials and access a user's data using OAuth credentials

Background:
  Given "test" user successfully signed up

Scenario: a client can register as an OAuth consumer
  Given "external_client" is not registered as an OAuth consumer
  When "test" user registers "external_client" as an OAuth consumer
  Then "external_client" is registered as an OAuth consumer
    And "test" user can access the OAuth keys for "external_client"

Scenario: a client can consume a user's data using OAuth credentials
  Given "test" user successfully registered "external_client" as an OAuth consumer
  When "test" user does the OAuth dance with "external_client"
    And "external_client" tries to access "test" user's data using the OAuth token
  Then "test" user can access the data.  
    And there's an awesome http response

Scenario: a user can revoke OAuth access

