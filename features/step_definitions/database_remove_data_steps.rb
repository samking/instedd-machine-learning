require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

def choose_random_row(username)
  rows = get_dataset_from_username(username).database_table.as_map.keys
  rows[rand(rows.length)]
end

def choose_random_col(row)
  cols = row.keys
  cols[rand(cols.length)]
end

def set_row_to_delete(username, real_row)
  if real_row == "real" 
    @row_to_delete = choose_random_row(username)
  elsif real_row == "fake"
    @row_to_delete = "thisRowShouldNotExist"
  else
    fail
  end
end

def set_col_to_delete(username, real_col)
  if real_col == "real"
    row = get_dataset_from_username(username).database_table.as_map[@row_to_delete]
    assert_not_nil row
    @col_to_delete = choose_random_col(row)
  elsif real_col == "fake"
    @col_to_delete = "thisColShouldNotExist"
  else
    fail
  end
end

When /^(?:the |)#{QUOTED_ARG} user deletes a #{QUOTED_ARG} row in (?:the |)#{QUOTED_ARG} user's table$/ do |deleter_username, real_row, deleted_username|
  authenticate_user(deleter_username)
  set_row_to_delete(deleted_username, real_row)
  visit(dataset_path(get_dataset_from_username(deleted_username)[:id]) + '.xml', :put, :remove_rows => @row_to_delete)
end

When /^the row that was just deleted should not be in (?:the |)#{QUOTED_ARG} user's table$/ do |username|
  deleted_row = get_dataset_from_username(username).database_table.as_map[@row_to_delete]
  assert_nil deleted_row, "We should have deleted the #{@row_to_delete} row from #{username} user's table.  Instead, the row exists.  It is #{deleted_row}."
end

When /^(?:the |)#{QUOTED_ARG} user deletes a #{QUOTED_ARG} column from a #{QUOTED_ARG} row in (?:the |)#{QUOTED_ARG} user's table$/ do |deleter_username, real_col, real_row, deleted_username|
  authenticate_user(deleter_username)
  set_row_to_delete(deleted_username, real_row)
  set_col_to_delete(deleted_username, real_col)
  visit(dataset_path(get_dataset_from_username(deleted_username)[:id]) + '.xml', :put, {:remove_rows => @row_to_delete, :remove_cols => @col_to_delete})
end

When /^the element that was just deleted should not be in (?:the |)#{QUOTED_ARG} user's table$/ do |username|
  row = get_dataset_from_username(username).database_table.as_map[@row_to_delete]
  col = row[@col_to_delete]
  assert_nil col, "We should have deleted the #{@col_to_delete} column from the #{@row_to_delete} row, but we didn't.  The column: #{col}"
end

