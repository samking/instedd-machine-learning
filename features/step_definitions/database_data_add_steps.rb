require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client adds the #{QUOTED_ARG} file to the database using the web interface$/ do |filename|
  visit dataset_path @test_client[:id]
  Then "I fill in \"data_url\" with \"#{$TEST_HOST}/tests/#{filename}\""
  Then 'I press "Modify Data and/or run Machine Learning"'
end

When /^the test client adds the #{QUOTED_ARG} file to the database using the api$/ do |filename|
  visit(dataset_path(@test_client[:id]) + '.xml', :put, :data_url => "#{$TEST_HOST}/tests/#{filename}")
end

When /^the test client successfully added the #{QUOTED_ARG} csv file to the database$/ do |filename|
  Then "we have a \"#{filename}\" test file"
    And "the test client adds the \"#{filename}\" file to the database using the api"
    And "the response to the api should have code \"200\""
    And "the contents of the \"#{filename}\" csv file is in the database"
end

