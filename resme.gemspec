# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resme/version"

Gem::Specification.new do |spec|
  spec.name          = "resme"
  spec.version       = Resme::VERSION
  spec.authors       = ["Adolfo Villafiorita"]
  spec.email         = ["adolfo.villafiorita@me.com"]

  spec.summary       = %q{Write a resume in YML and export to various formats, including json and europass XML}
  spec.description   = %q{This gem allows you to manage your resume in yaml, while providing different backends for publishings.  Supported backends: markdown, json resume, and Europass XML.  Custom templates can be defined using ERB.}
  spec.homepage      = "http://github.io/avillafiorita/resme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "slop", "~> 4.5.0"
  spec.add_dependency "kwalify", "~> 0.7.2"
end
