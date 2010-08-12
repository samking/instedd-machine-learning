require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^(?:the |)#{QUOTED_ARG} user runs machine learning using the #{QUOTED_ARG} service$/ do |username, service|
  authenticate_user(username)
  visit(dataset_path(get_dataset_from_username(username)[:id]), :put, :service => service)
end

When /^(?:the |)#{QUOTED_ARG} user has no machine learning running$/ do |username|
  authenticate_user(username)
  assert_false get_dataset_from_username(username).is_learning?
end

