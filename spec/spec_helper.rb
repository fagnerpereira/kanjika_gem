# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "kanjika"

module SpecHelpers
  def mecab_installed?
    @mecab_installed ||= system("mecab --version > /dev/null 2>&1")
  end
end

RSpec.configure do |config|
  config.include SpecHelpers

  config.before(:each) do |example|
    if example.metadata[:needs_mecab] && !mecab_installed?
      pending "MeCab is not installed"
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
