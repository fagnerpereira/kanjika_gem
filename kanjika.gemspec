# frozen_string_literal: true

require_relative "lib/kanjika/version"

Gem::Specification.new do |spec|
  spec.name = "kanjika"
  spec.version = Kanjika::VERSION
  spec.authors = ["Fagner Pereira Rosa"]
  spec.email = ["fagnerfpr@gmail.com"]

  spec.summary = "Useful tools to work with Japanese language"
  spec.description = "A comprehensive Ruby gem for Japanese verb conjugation supporting masu, te, and potential forms across all verb types (godan, ichidan, and irregular)"
  spec.homepage = "https://github.com/fagnerpereira/kanjika_gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fagnerpereira/kanjika_gem"
  spec.metadata["bug_tracker_uri"] = "https://github.com/fagnerpereira/kanjika_gem/issues"
  spec.metadata["changelog_uri"] = "https://github.com/fagnerpereira/kanjika_gem/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/fagnerpereira/kanjika_gem#readme"

  spec.files = Dir["{lib,examples}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  # spec.add_dependency "railties"
  # https://github.com/kimtaro/ve
  spec.add_dependency "ve", "~> 0.0.4"
  spec.add_dependency "mojinizer", "~> 0.2.2"
  spec.add_dependency "activesupport", ">= 7.0"
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
