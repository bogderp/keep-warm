# frozen_string_literal: true

require 'keep_warm'
require 'fileutils'

RSpec.configure do |config|
  original_stdout = $stdout
  config.before(:suite) do
    $stdout = File.open(File::NULL, 'w')
  end

  config.after(:suite) do
    $stdout = original_stdout
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = 'spec/reports/examples.txt'

  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
