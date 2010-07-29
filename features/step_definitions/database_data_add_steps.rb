require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client adds the #{QUOTED_ARG} file to the database using the web interface$/ do |filename|
  visit dataset_path 'test'
  Then "I fill in \"data_url\" with \"http://localhost:3000/tests/#{filename}\""
  Then 'I press "Modify Data and/or run Machine Learning"'
end

When /^the test client adds the #{QUOTED_ARG} file to the database using the api$/ do |filename|
  visit(dataset_path('test') + '.xml', :put, :data_url => "/tests/#{filename}")
end

