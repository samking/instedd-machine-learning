require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client adds the #{QUOTED_ARG} file to the database using the web interface$/ do |filename|
  visit dataset_path @test_client[:id]
  Then "I fill in \"data_url\" with \"#{$TEST_HOST}/tests/#{filename}\""
  Then 'I press "Modify Data and/or run Machine Learning"'
end

When /^the test client adds the #{QUOTED_ARG} file to the database using the api$/ do |filename|
  visit(dataset_path(@test_client[:id]) + '.xml', :put, :data_url => "#{$TEST_HOST}/tests/#{filename}")
end

