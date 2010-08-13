When /^(?:the |)#{QUOTED_ARG} user views the index of database tables$/ do |username|
  authorize_user(username)
  visit(datasets_path + '.xml')
end
