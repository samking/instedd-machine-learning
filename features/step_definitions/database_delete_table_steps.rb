When /^(?:the |)#{QUOTED_ARG} user successfully deletes their table in the remote database$/ do |username|
  Then "the \"#{username}\" user should have a table in the remote database"
    And "the \"#{username}\" user deletes their table in the remote database using the api"
    And "the \"#{username}\" user doesn't have a table in the remote database"
end

When /^(?:the |)#{QUOTED_ARG} user deletes their table in the remote database using the api$/ do |username|
  authenticate_user(username)
  visit(dataset_path(get_dataset_from_username(username)[:id]), :delete)
end

When /^(?:the |)#{QUOTED_ARG} user deletes their table in the remote database$/ do |username|
  Then "the \"#{username}\" user deletes the table in the remote database using the api"
  #Then "the \"#{username}\" user deletes the table in the remote database using the web interface"
end

