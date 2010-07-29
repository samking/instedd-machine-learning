require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

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
  pending
  url = "http://localhost:3000/test/#{filename}"
  element = get_random_csv_element(open(url))
  dataset = Dataset.find('test')
  assert dataset.database_has_element? element
end

When /^the test client views their database table using the api$/ do
  visit(dataset_path('test'))
end

