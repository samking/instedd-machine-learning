When /^the test client signs up for a table in the remote database using the api$/ do
  visit('/datasets.xml', :post)
  xml_response = response_body
  xml_parser = REXML::Document.new xml_response
  id_node = xml_parser.root.detect {|node| node.kind_of? REXML::Element and node.name == "id"}
  uuid_node = xml_parser.root.detect {|node| node.kind_of? REXML::Element and node.name == "client-uuid"}
  @test_client = {:id => id_node.text.to_i, :uuid => uuid_node.text}
  @test_client[:dataset] = Dataset.find(@test_client[:id])
end

When /^the test client signs up for a table in the remote database using the web interface$/ do
  Then "I go to the new dataset page"
    And "I press \"dataset_submit\""

end

When /^the test client signs up for a table in the remote database$/ do
  Then "the test client signs up for a table in the remote database using the api"
  #Then "the test client signs up for a table in the remote database using the web interface"
end

When /^the test client successfully signed up for a table in the remote database$/ do
  Then "the test client signs up for a table in the remote database"
    And "the test client should have a table in the remote database"
end

When /^the test client doesn't have a correct login$/ do
  @test_client = {:id => -1, :uuid => UUIDTools::UUID.random_create.to_s}
end

