# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require_relative '../lib/vending/vending.rb'
require_relative 'support/model_helpers.rb'

RSpec.configure do |config|
  include ModelHelpers
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
