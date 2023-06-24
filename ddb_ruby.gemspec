# frozen_string_literal: true

require_relative "lib/ddb_ruby/version"

Gem::Specification.new do |spec|
  spec.name = "ddb_ruby"
  spec.version = DdbRuby::VERSION
  spec.authors = ["Aaron F Stanton"]
  spec.email = ["afstanton@gmail.com"]

  spec.summary = "Read DDB JSON in Ruby."
  spec.homepage = "https://github.com/afstanton/ddb_ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] =  "https://github.com/afstanton/ddb_ruby"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
    "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ externals/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "multi_json", "~> 1.15"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
