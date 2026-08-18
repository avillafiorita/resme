# frozen_string_literal: true

require_relative "lib/resme/version"

Gem::Specification.new do |spec|
  spec.name = "resme"
  spec.version = Resme::VERSION
  spec.authors = ["Adolfo Villafiorita"]
  spec.email = ["adolfo@shair.tech"]

  spec.summary = "Keep your resume in YML and export to various formats"
  spec.description =
    "Manage your resume in YAML and publish with Org Mode or JSON resume." \
    "Org Mode provides HTML, TXT, LaTeX, Markdown exports." \
    "JSON Resume comes with many ready-made templates."
  spec.homepage = "https://github.com/avillafiorita/resme"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/avillafiorita/resme"
  spec.metadata["changelog_uri"] = "https://github.com/avillafiorita/resme/CHANGELOG.org"

  # Uncomment the line below to require MFA for gem pushes.
  # This helps protect your gem from supply chain attacks by ensuring
  # no one can publish a new version without multi-factor authentication.
  # See: https://guides.rubygems.org/mfa-requirement-opt-in/
  # spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore test/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "classy_hash"

  # For more information and examples about making a new gem, check out our
  # guide at: https://guides.rubygems.org/make-your-own-gem/
end
