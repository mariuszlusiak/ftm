# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ftm_session',
  :secret      => 'b164485af7334c1e83d9dc87ee51492433cf382a6a86f7d0d49a2f36d18d396e270e414f122a442adf1754ac2fe426173f1a4184a3cf9885238140dcc1251d33'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
