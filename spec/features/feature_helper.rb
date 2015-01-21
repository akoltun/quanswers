require 'rails_helper'
require 'capybara/email/rspec'
# require 'capybara/poltergeist'

RSpec.configure do |config|
  # Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :webkit

  config.include FeatureHelper, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    # if Rails.env.test?
    #   FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    # end
  end
end