require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^I will fail with a #{QUOTED_ARG} exception if (.*)$/ do |exception_type, exceptional_step|
  assert_raise exception_type.constantize do 
    Then exceptional_step
  end
end

