require "bundler/setup"
require "amdirent_stripe"

require 'active_record'
require 'pry'
require 'dotenv/load'
require 'customer'

connection_info = {
  host: "localhost",
  port: 5432,
  database: "amdirent_stripe_test",
  adapter: "postgresql"
}

ActiveRecord::Base.establish_connection(connection_info)
require "migrate/001_create_customers.rb"

CreateCustomers.new.migrate(:up) unless ActiveRecord::Base.connection.table_exists? 'customers'

Stripe.api_key = ENV['STRIPE_API_KEY']

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
