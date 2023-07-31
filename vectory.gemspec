# frozen_string_literal: true

require_relative "lib/vectory/version"

Gem::Specification.new do |spec|
  spec.name          = "vectory"
  spec.version       = Vectory::VERSION
  spec.authors       = ["Ribose Inc."]
  spec.email         = ["open.source@ribose.com"]

  spec.summary       = "Pairwise vector image conversions."
  spec.description   = <<~DESCRIPTION
    Vectory performs pairwise vector image conversions for common
    vector image formats, such as SVG, EMF, EPS and PS.
  DESCRIPTION

  spec.homepage      = "https://github.com/metanorma/vectory"
  spec.license       = "BSD-2-Clause"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.files         = `git ls-files`.split("\n")
  spec.required_ruby_version = ">= 2.5.0"

  spec.add_runtime_dependency "emf2svg"
  spec.add_runtime_dependency "thor", "~> 1.2.1"
  spec.add_runtime_dependency "marcel", "~> 1.0.0"

  spec.add_development_dependency "equivalent-xml", "~> 0.6"
  spec.add_development_dependency "htmlentities", "~> 4.3.4"
  spec.add_development_dependency "nokogiri", "~> 1.14"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.22.1"
  spec.add_development_dependency "rubocop-rails", "~> 2.9"
  spec.add_development_dependency "rubocop-performance", "~> 1.10"
end
