When /^the test client (?:doesn't|shouldn't) have a table in the remote database$/ do
  assert_false Dataset.has_database_table? "test"
end

When /^the test client should have a table in the remote database$/ do
  assert Dataset.has_database_table? "test"
end


