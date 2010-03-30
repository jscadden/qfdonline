# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qfdonline_new_session',
  :secret      => 'f506bbc75dd1eaebc30fb05324e532eb1480619442dae9c81f94055a2d69f634c5407176a559ea06ed661954893dcb34d7326b78330dbcfe5c1aa7015a4ec912'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
