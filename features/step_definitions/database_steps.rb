require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

When /^the test client (?:doesn't|shouldn't) have a table in the remote database$/ do
  assert_false Dataset.has_database_table? "test"
end

When /^the test client should have a table in the remote database$/ do
  assert Dataset.has_database_table? "test"
end

When /^the test client signs up for a table in the remote database using the api$/ do
  visit('/datasets.xml', :post, {'dataset[uid]' => 'test'})
end

When /^the test client signs up for a table in the remote database using the web interface$/ do
  Then "I go to the new dataset page"
    And "I fill in \"dataset_uid\" with \"test\""
    And "I press \"dataset_submit\""

end

When /^the test client signs up for a table in the remote database$/ do
  Then "the test client signs up for a table in the remote database using the api"
  #Then "the test client signs up for a table in the remote database using the web interface"
end

When /^the test client successfully deletes the table in the remote database$/ do
  Then "the test client should have a table in the remote database"
    And "the test client deletes the table in the remote database using the api"
    And "the test client doesn't have a table in the remote database"
end

When /^the test client deletes the table in the remote database using the api$/ do
  visit('/datasets/test.xml', :delete)
end

When /^I cannot view the test client's page$/ do
  assert_raise ActiveRecord::RecordNotFound do 
    visit('/datasets/test.xml') 
  end
end

When /^the response to the api should have code #{QUOTED_ARG}$/ do |desired_code|
  assert_equal desired_code.to_i, response.response_code, "The HTTP response code should have been #{desired_code} but was #{response.response_code}"
end

When /^the body of the response to the api should include #{QUOTED_ARG}$/ do |desired_body|
  assert_match desired_body, response.body, "The response should have included '#{desired_body}' but didn't.  The response: #{response.body}"
end

When /^the test client deletes the table in the remote database using the web interface$/ do
  visit dataset_path 'test'
  Then "I follow \"Destroy\""
end

When /^the test client deletes the table in the remote database$/ do
  Then "the test client deletes the table in the remote database using the api"
  #Then "the test client deletes the table in the remote database using the web interface"
end

When /^the test client successfully signed up for a table in the remote database$/ do
  Then "the test client doesn't have a table in the remote database"
    But "the test client signs up for a table in the remote database"
    And "the test client should have a table in the remote database"
end

When /^we have a #{QUOTED_ARG} file$/ do |filename|
  pending
  url = 'http://localhost:3000/test/' + filename
  file_curl = Curl::Easy.new(url)
  file_curl.head = true #we only want to know if it's there, not get the whole thing
  file_curl.perform
  assert_equal file_curl.response_code, 200, "The server didn't respond with HTTP 200 when we tried to access the file at #{url}"
end

When /^the test client adds the #{QUOTED_ARG} file to the database using the web interface$/ do |filename|
  visit dataset_path 'test'
  Then "I fill in \"dataurl\" with \"http://localhost:3000/test/#{filename}\""
  Then 'I press "Modify Data and/or run Machine Learning"'
end

def get_random_csv_element(file_descriptor)
  rows = []
  begin
    CSV::Reader.parse(file_descriptor) {|row| rows << row}
    row = rows[rand(rows.length)]
    elem = row[rand(row.length)]
  end while not elem.blank?
  elem
end


When /^the contents of the #{QUOTED_ARG} csv file is in the database$/ do |filename|
  url = "http://localhost:3000/test/#{filename}"
  element = get_random_csv_element(open(url))
  dataset = Dataset.find('test')
  assert dataset.database_has_element? element
end

#test "should delete account in db" do
#  @dataset.save 
#  assert @dataset.destroy
#end
#
#test "should accept a normal account not in db" do
#  assert @dataset.save, "failed to save dataset: #{@dataset.errors.full_messages}"
#  @dataset.destroy
#end
#
#test "should appear in db after posted" do
#  @dataset.save
#  assert Dataset.sdb.list_domains[:domains].include? @dataset.uid
#  @dataset.destroy
#end

