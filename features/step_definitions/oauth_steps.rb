require File.expand_path(File.join(File.dirname(__FILE__), "quoted_arg_constant"))

def get_client_application_by_name(application_name)
  ClientApplication.first(:conditions => {:name => application_name})
end

When /^#{QUOTED_ARG} is not registered as an OAuth consumer$/ do |consumer_name|
  application = get_client_application_by_name(consumer_name) 
  assert_nil application, "#{consumer_name} wasn't supposed to have an application, but it did.  The application: #{application.inspect}"
end

When /^#{QUOTED_ARG} user registers #{QUOTED_ARG} as an OAuth consumer$/ do |username, consumer_name|
  authenticate_user(username)
  visit(oauth_clients_path + '.xml', :post, {:client_application => {:name => consumer_name, :url => $TEST_HOST, :callback_url => $TEST_HOST}})
end

When /^#{QUOTED_ARG} is registered as an OAuth consumer$/ do |consumer_name|
  application = get_client_application_by_name(consumer_name)
  assert_not_nil application, "#{consumer_name} was supposed to have an application, but it didn't."
end

When /^#{QUOTED_ARG} user (?:can access|accesses) the OAuth keys for #{QUOTED_ARG}$/ do |username, consumer_name|
  application =get_client_application_by_name(consumer_name)
  user_applications = get_user_by_name(username).client_applications
  assert(user_applications.include?(application), 
         "#{username} should own the #{consumer_name} application.  
         The application: #{application.inspect}.  
         Owned applications: #{user_applications.inspect}"
        )

  authenticate_user(username)
  visit(oauth_client_path(application) + '.xml')
  @oauth_info = get_xml_properties(response_body, [:key, :secret])
  assert_not_nil oauth_info[:key], "#{username} should be able to see the key, but couldn't"
  assert_not_nil oauth_info[:secret], "#{username} should be able to see the secret, but couldn't"
end

When /^#{QUOTED_ARG} user successfully registered #{QUOTED_ARG} as an OAuth consumer$/ do |username, consumer_name|
  Then "\"#{consumer_name}\" is not registered as an OAuth consumer"
    And "\"#{username}\" user registers \"#{consumer_name}\" as an OAuth consumer"
    And "\"#{consumer_name}\" is registered as an OAuth consumer"
    And "\"#{username}\" user can access the OAuth keys for \"#{consumer_name}\""
end

When /^#{QUOTED_ARG} user does the OAuth dance with #{QUOTED_ARG}$/ do |username, consumer_name|
  #get consumer token
  Then "\"#{username}\" user accesses the OAuth keys for \"#{consumer_name}\""
  consumer = OAuth::Consumer.new(@oauth_info[:key], @oauth_info[:secret], {
    :site               => $TEST_HOST,
    #:scheme             => :header,
    #:http_method        => :post,
    :request_token_path => "/oauth/request_token",
    :access_token_path  => "/oauth/access_token",
    :authorize_path     => "/oauth/authorize"
  })

  #get request token
  request_token = consumer.get_request_token

  #authorize the request token
  #the user authenticates themselves and authorizes the request at request_token.authorize_url
  #session[:request_token] = @request_token
  #redirect_to @request_token.authorize_url

  #get the access token
  @access_token = @request_token.get_access_token
end

