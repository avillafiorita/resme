# frozen_string_literal: true

module Resme
  #
  # Parse command line
  #
  class Cli
    attr_reader :options

    def initialize(arguments)
      # no arguments is equivalent to --help
      @arguments = arguments == [] ? ["--help"] : arguments
    end

    def parse
      @options = {}
      parser.parse!(@arguments)
    end

    def command
      @options[:cmd]
    end

    private

    def parser
      OptionParser.new do |parser|
        parser.banner = "resme [options] - Format and manage a resume in YAML"

        # parser.on("-o", "--output FILENAME", String, "Output filename") do |v|
        #   @options[:output] = v
        # end

        parser.on("--format FORMAT", String, "Output format") do |v|
          @options[:format] = v
        end

        parser.on("--init", "Init a new resume") do |v|
          @options[:cmd] = :init
        end

        parser.on("--validate FILENAME", "Validate the resume") do |v|
          @options[:cmd] = :validate
          @options[:filename] = v
        end

        parser.on("--build FILENAME", "Build the resume in FILENAME") do |v|
          @options[:cmd] = :build
          @options[:filename] = v
        end

        parser.on("--sections FILENAME", "List sections in FILENAME") do |v|
          @options[:cmd] = :sections
          @options[:filename] = v
        end

        parser.on("--list", "List available templates") do |v|
          @options[:cmd] = :list
        end

        parser.on("--except x,y,z", Array, "Excluded section") do |v|
          @options[:except] = v.map { |x| x.to_sym }
        end

        parser.on("--cat TEMPLATE", "View a template") do |v|
          @options[:cmd] = :cat
          @options[:template] = v
        end

        parser.on("--version") do |_|
          @options[:cmd] = :version
        end

        parser.on("-h", "--help", "Print this help") do
          puts parser
        end
      end
    end
  end
end
