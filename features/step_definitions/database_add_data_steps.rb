require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^(?:the |)#{QUOTED_ARG} user adds the #{QUOTED_ARG} file to the database using the web interface$/ do |username, filename|
  visit dataset_path @test_client[:id]
  Then "I fill in \"data_url\" with \"#{$TEST_HOST}/tests/#{filename}\""
  Then 'I press "Modify Data and/or run Machine Learning"'
end

When /^(?:the |)#{QUOTED_ARG} user adds the #{QUOTED_ARG} file to their database table using the api$/ do |username, filename|
  authenticate_user(username)
  visit(dataset_path(get_dataset_from_username(username)[:id]) + '.xml', :put, :data_url => "#{$TEST_HOST}/tests/#{filename}")
end

When /^(?:the |)#{QUOTED_ARG} user successfully added the #{QUOTED_ARG} csv file to their database table$/ do |username, filename|
  Then "we have a \"#{filename}\" test file"
    And "the \"#{username}\" user adds the \"#{filename}\" file to their database table using the api"
    And "the response to the api should have code \"200\""
    And "the \"#{username}\" user has the contents of the \"#{filename}\" csv file in their database table"
end

