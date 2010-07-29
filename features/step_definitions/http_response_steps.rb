require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the response to the api should have code #{QUOTED_ARG}$/ do |desired_code|
  assert_equal desired_code.to_i, response.response_code, "The HTTP response code should have been #{desired_code} but was #{response.response_code}"
end

When /^the body of the response to the api should include #{QUOTED_ARG}$/ do |desired_body|
  assert_match desired_body, response.body, "The response should have included '#{desired_body}' but didn't.  The response: #{response.body}"
end

When /^the body of the xml response to the api should include (?:a|an) #{QUOTED_ARG} field$/ do |desired_field|
  xml_parser = REXML::Document.new response_body
  desired_node = xml_parser.root.detect {|node| node.kind_of? REXML::Element and node.name == desired_field}
  assert_not_nil desired_node, "The XML response was supposed to have the #{desired_field} field, but it didn't.  The response: #{response_body}"
end


When /^we have a #{QUOTED_ARG} test file$/ do |filename|
  visit("/tests/#{filename}")
  Then 'the response to the api should have code "200"' 
end

