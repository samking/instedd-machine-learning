require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client runs machine learning using the #{QUOTED_ARG} service$/ do |service|
  visit(dataset_path(@test_client[:id]), :put, :service => service)
end

When /^the test client has no machine learning running$/ do
  assert_false @test_client[:dataset].is_learning?
end

