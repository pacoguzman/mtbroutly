# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
    :key => '_mtbroutly_session',
    :secret      => '59359f7e9c1a081ba686ae0a84d38b3ab2761c8356dc28e7ac045bf3fde1cf433b56aa856405d976bbcfb483e914c349105ddc6751ce3a64b96a1416baa4c431'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store