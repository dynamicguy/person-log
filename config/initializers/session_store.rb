# Be sure to restart your server when you modify this file.

PersonLog::Application.config.session_store :cookie_store, :key => '_person-log_session', :secret => '#what do you expect here to be?'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# PersonLog::Application.config.session_store :active_record_store

#PersonLog::Application.config.session_store :active_record_store
