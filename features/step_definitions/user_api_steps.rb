
When /^no #{QUOTED_ARG} user exists$/ do |username|
  Then "no user with login: '#{username}' exists"
end

When /^(?:the |)#{QUOTED_ARG} user exists$/ do |username|
  Then "a user with login: '#{username}' should exist"
end

When /^(?:the |)#{QUOTED_ARG} user sign(?:s|ed) up(?: using the api)$/ do |username|
  user_properties = {:login => username, :password => "password", :password_confirmation => "password", :email => "#{username}@example.com"} 
  visit(users_path + '.xml', :post, "user" => user_properties)
  @user_passwords ||= {}
  @user_passwords[username.to_sym] = user_properties[:password]
end

When /^(?:the |)#{QUOTED_ARG} user successfully sign(?:s|ed) up$/ do |username|
  Then "no \"#{username}\" user exists"
    And "the \"#{username}\" user signs up using the api"
    And "the \"#{username}\" user exists"
end

When /^(?:the |)#{QUOTED_ARG} user deletes their account$/ do |username|
  authenticate_user(username)
  visit(user_path(get_user_by_name(username)) + '.xml', :delete)
end

When /^(?:the |)#{QUOTED_ARG} user has the property #{QUOTED_ARG} set to #{QUOTED_ARG}$/ do |username, property, value|
  user = get_user_by_name(username)
  assert_equal value, user[property.to_sym].to_s, 
    "The #{username} user was supposed to have the #{property} property set to #{value}, but instead it was #{user[property.to_sym]}."
end

When /^(?:the |)#{QUOTED_ARG} user toggles (?:the |)#{QUOTED_ARG} user's admin status$/ do |toggler_username, toggled_username|
  authenticate_user(toggler_username)
  visit(user_path(get_user_by_name(toggled_username)) + '/toggle_admin.xml', :put)
end

def get_user_by_name(username)
  User.first(:conditions => {:login => username})
#  user = instance_variable_get("@#{username}_user".to_sym)
#  if refresh
#    db_user = User.find(user[:id])
#    user.each do |key, val|
#      db_val = db_user.method(key).call
#      user[key] = db_val unless db_val.nil?
#    end
#  end
#  return user
end

#will return an arbitrary dataset owned by the user if the user owns more than one
def get_dataset_from_username(username)
  get_datasets_from_username(username)[0]
end

def get_datasets_from_username(username)
  get_user_by_name(username).datasets
end

