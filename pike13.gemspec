# frozen_string_literal: true

require_relative "lib/pike13/version"

Gem::Specification.new do |spec|
  spec.name = "pike13"
  spec.version = Pike13::VERSION
  spec.authors = ["Juan Huttemann"]
  spec.email = ["juanfhuttemann@gmail.com"]

  spec.summary = "Ruby client for the Pike13 API"
  spec.description = "A Ruby gem for interacting with the Pike13 API"
  spec.homepage = "https://github.com/juanhuttemann/pike13-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/juanhuttemann/pike13-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/juanhuttemann/pike13-ruby/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
                          lib/**/*.rb
                          LICENSE.txt
                          README.md
                          CHANGELOG.md
                        ])
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
end
