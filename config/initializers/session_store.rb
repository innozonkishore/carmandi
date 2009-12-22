# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_carmandi_session',
  :secret      => '01006d77e4cbe630cc6197a462c5e14d3d38e988431032f1623fd7cbe2872e0f9c415474e1a5f249624f02e4f2d6ca65ddb951138abe1fd57ca79db8dd3944c5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
