# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PersonLog::Application.initialize!
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:primary_key] = "BIGSERIAL PRIMARY KEY"