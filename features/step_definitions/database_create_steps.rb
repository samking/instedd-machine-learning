When /^the test client signs up for a table in the remote database using the api$/ do
  visit('/datasets.xml', :post, {'dataset[uid]' => 'test'})
end

When /^the test client signs up for a table in the remote database using the web interface$/ do
  Then "I go to the new dataset page"
    And "I fill in \"dataset_uid\" with \"test\""
    And "I press \"dataset_submit\""

end

When /^the test client signs up for a table in the remote database$/ do
  Then "the test client signs up for a table in the remote database using the api"
  #Then "the test client signs up for a table in the remote database using the web interface"
end

When /^the test client successfully signed up for a table in the remote database$/ do
  Then "the test client doesn't have a table in the remote database"
    But "the test client signs up for a table in the remote database"
    And "the test client should have a table in the remote database"
end

