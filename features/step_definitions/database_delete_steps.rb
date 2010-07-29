When /^the test client successfully deletes the table in the remote database$/ do
  Then "the test client should have a table in the remote database"
    And "the test client deletes the table in the remote database using the api"
    And "the test client doesn't have a table in the remote database"
end

When /^the test client deletes the table in the remote database using the api$/ do
  visit((dataset_path('test') + '/datasets/test.xml'), :delete)
end

When /^the test client deletes the table in the remote database using the web interface$/ do
  visit dataset_path 'test'
  Then "I follow \"Destroy\""
end

When /^the test client deletes the table in the remote database$/ do
  Then "the test client deletes the table in the remote database using the api"
  #Then "the test client deletes the table in the remote database using the web interface"
end

