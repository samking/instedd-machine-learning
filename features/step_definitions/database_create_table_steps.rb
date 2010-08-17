When /^(?:the |)#{QUOTED_ARG} user signs up for a table in the remote database using the api$/ do |username|
  authenticate_user(username)
  visit('/datasets.xml', :post, "dataset[name]" => username)
  #user = get_user_by_name(username)
  #user[:datasets] = get_xml_properties(response_body, ["id", "table-uuid"])
  #user[:datasets][:dataset] = Dataset.find(user[:dataset][:id])
end

When /^(?:the |)#{QUOTED_ARG} user signs up for a table in the remote database using the web interface$/ do |username|
  Then "I go to the new dataset page"
    And "I press \"dataset_submit\""
end

When /^(?:the |)#{QUOTED_ARG} user signs up for a table in the remote database$/ do |username|
  Then "\"#{username}\" user signs up for a table in the remote database using the api"
end

When /^(?:the |)#{QUOTED_ARG} user successfully signed up for a table in the remote database$/ do |username|
  Then "\"#{username}\" user signs up for a table in the remote database"
    And "\"#{username}\" user should have a table in the remote database"
end

