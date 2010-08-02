When /^I view the test client's page(?:| using the api)$/ do
  visit(dataset_path(@test_client[:id]) + '.xml')
end

When /^the test client (?:doesn't|shouldn't) have a table in the remote database$/ do
  assert_false DatabaseInterface.has_table? @test_client[:uuid]
end

When /^the test client should have a table in the remote database$/ do
  assert DatabaseInterface.has_table? @test_client[:uuid]
end


