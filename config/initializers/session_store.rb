# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_instedd-ml_session',
  :secret      => 'e8f40772474bc50be4a29b1216c8ba346291c1ab9b9599ff8677f87238f136fdf754a4bc8f4b2450cfcb44332959c44a7e0b329c232313b78f5dd11d8e4f9422'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
