# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qfd2_session',
  :secret      => 'ea1f26fe61d768db8db08145ebcd3c665f95001fa558d6a190632acc945d8daf2de1dc89b2d658810500b8919493bd07bf4b3c77b1530de980624869aa96471c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
