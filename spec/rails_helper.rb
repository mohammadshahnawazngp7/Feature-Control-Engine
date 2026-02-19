require 'simplecov'

# Start SimpleCov before loading the Rails environment
SimpleCov.start 'rails' do
  add_filter '/spec/'        # Exclude spec files
  add_filter '/config/'      # Exclude config files
  add_filter '/vendor/'      # Exclude vendor gems

  # Group your app folders for nicer coverage report
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Libraries', 'lib'

  # Track coverage for all files even if not loaded yet
  track_files 'app/**/*.rb'
end

puts "SimpleCov started: tracking coverage..."


require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!


begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true



  #

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
end
