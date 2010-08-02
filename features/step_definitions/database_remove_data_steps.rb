require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

def choose_random_row
  rows = @test_client[:dataset].database_table.as_map.keys
  rows[rand(rows.length)]
end

def choose_random_col(row)
  cols = row.keys
  cols[rand(cols.length)]
end

def set_row_to_delete(real_row)
  if real_row == "real" 
    @row_to_delete = choose_random_row
  elsif real_row == "fake"
    @row_to_delete = "thisRowShouldNotExist"
  else
    fail
  end
end

def set_col_to_delete(real_col)
  if real_col == "real"
    row = @test_client[:dataset].database_table.as_map[@row_to_delete]
    assert_not_nil row
    @col_to_delete = choose_random_col(row)
  elsif real_col == "fake"
    @col_to_delete = "thisColShouldNotExist"
  else
    fail
  end
end

When /^we delete a #{QUOTED_ARG} row in the test client's table$/ do |real_row|
  set_row_to_delete(real_row)
  visit(dataset_path(@test_client[:id]) + '.xml', :put, :remove_rows => @row_to_delete)
end

Then /^there should be #{QUOTED_ARG} rows in the test client's table$/ do |desired_num_rows| 
  num_rows = @test_client[:dataset].database_table.as_map.size 
  assert_equal(desired_num_rows.to_i, num_rows,
               "There should have been #{desired_num_rows} rows.  Instead, there were #{num_rows}")
end

Then /^#{QUOTED_ARG} row(?:|s) in the test client's table should have #{QUOTED_ARG} columns$/ do |num_rows_to_check, desired_num_cols| 
  rows, cols_arr = @test_client[:dataset].database_table.as_array
  num_rows_with_correct_cols = cols_arr.select{|cols| cols.size == desired_num_cols.to_i}.size
  assert_equal(num_rows_with_correct_cols, num_rows_to_check.to_i, 
               "There should have been #{num_rows_to_check} rows with #{desired_num_cols} columns.  Instead, there were #{num_rows_with_correct_cols}")
end

Then /^the row that the test client deleted should not be in the test client's table$/ do 
  deleted_row = @test_client[:dataset].database_table.as_map[@row_to_delete]
  assert_nil deleted_row, "We should have deleted the #{@row_to_delete} row.  Instead, the row exists.  It is #{deleted_row}."
end

When /^we delete a #{QUOTED_ARG} column from a #{QUOTED_ARG} row in the test client's table$/ do |real_col, real_row|
  set_row_to_delete(real_row)
  set_col_to_delete(real_col)
  visit(dataset_path(@test_client[:id]) + '.xml', :put, {:remove_rows => @row_to_delete, :remove_cols => @col_to_delete})
end

And /^the element that the test client deleted should not be in the test client's table$/ do
  row = @test_client[:dataset].database_table.as_map[@row_to_delete]
  col = row[@col_to_delete]
  assert_nil col, "We should have deleted the #{@col_to_delete} column from the #{@row_to_delete} row, but we didn't.  The column: #{col}"
end

