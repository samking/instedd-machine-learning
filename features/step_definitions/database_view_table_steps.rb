When /^(?:the |)#{QUOTED_ARG} user views (?:the |)#{QUOTED_ARG} user's database table using the api$/ do |viewer_username, viewed_username|
  authenticate_user(viewer_username)
  visit(dataset_path(get_dataset_from_username(viewed_username)[:id]) + '.xml')
end

When /^(?:the |)#{QUOTED_ARG} user (?:doesn't|shouldn't) have a table in the remote database$/ do |username|
  assert get_datasets_from_username(username).blank?, "The #{username} user wasn't supposed to have any tables in the remote database.  They had: #{get_datasets_from_username(username).inspect}."
  #assert_false DatabaseInterface.has_table? get_dataset_from_username(username)[:table_uuid]
end

When /^(?:the |)#{QUOTED_ARG} user should have a table in the remote database$/ do |username|
  assert DatabaseInterface.has_table? get_dataset_from_username(username)[:table_uuid]
end

