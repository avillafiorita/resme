require_relative 'lib/resme/version'

Gem::Specification.new do |spec|
  spec.name          = "resme"
  spec.version       = Resme::VERSION
  spec.authors       = ["Adolfo Villafiorita"]
  spec.email         = ["adolfo.villafiorita@ict4g.net"]

  spec.summary       = %q{Write a resume in YML and export to various formats, including json and europass XML.}
  spec.description   = %q{This gem allows you to manage your resume in yaml, while providing different backends for publishings.  Supported backends: markdown, json resume, and Europass XML.  Custom templates can be defined using ERB.}
  spec.homepage      = "http://github.io/avillafiorita/resme"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.io/avillafiorita/resme"
  spec.metadata["changelog_uri"] = "http://github.io/avillafiorita/resme"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0.1"

  spec.add_dependency "slop", "~> 4.8.1"
  spec.add_dependency "kwalify", "~> 0.7.2"
end
