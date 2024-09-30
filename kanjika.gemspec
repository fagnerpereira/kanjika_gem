# frozen_string_literal: true

require_relative "lib/kanjika/version"

Gem::Specification.new do |spec|
  spec.name = "kanjika"
  spec.version = Kanjika::VERSION
  spec.authors = ["Fagner Pereira Rosa"]
  spec.email = ["fagnerfpr@gmail.com"]

  spec.summary = "Usefull tools to work with japanese language"
  spec.description = "japanese language tools"
  spec.homepage = "https://github.com/fagnerpereira/kanjika_gem"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  # spec.add_dependency "railties"
  # https://github.com/kimtaro/ve
  spec.add_dependency "ve", "~> 0.0.4"

  spec.executables << "kanjika"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

