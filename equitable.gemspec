# frozen_string_literal: true

require_relative "lib/equitable"

Gem::Specification.new do |spec|
  spec.name = "equitable"
  spec.version = Equitable::VERSION
  spec.authors = ["Erik Berlin"]
  spec.email = ["sferik@gmail.com"]

  spec.summary = "Define equality, equivalence, and hashing methods for Ruby objects"
  spec.description = <<~DESCRIPTION
    Equitable provides a simple way to define equality (==), equivalence (eql?),
    and hashing (hash) methods for Ruby objects based on specified attributes.
    Includes pattern matching support and clean inspect output across Ruby versions.
  DESCRIPTION
  spec.homepage = "https://sferik.github.io/equitable/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sferik/equitable"
  spec.metadata["changelog_uri"] = "https://github.com/sferik/equitable/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?("bin/", "test/", "spec/", "features/", ".git", ".github", "Gemfile")
    end
  end
  spec.require_paths = ["lib"]
end
