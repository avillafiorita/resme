# frozen_string_literal: true

module Resme
  #
  # Execute!
  #
  class Executor
    # include all formatter helpers
    include Resme::Helper

    def initialize(input)
      @input = input
      @options = Cli.new(@input)
      @options.parse
    end

    # rubocop:disable Metrics
    def execute
      case @options.command
      when :init
        resume_template = File.join __dir__, "../../templates/resume.yml"
        puts File.read resume_template

      when :validate
        filename = @options.options[:filename]
        document = Document.new(filename)
        validator = DocumentValidator.new(document)
        validator.validate

      when :sections
        filename = @options.options[:filename]
        keys = Document.new(filename).data.keys
        puts keys

      when :build
        filename = @options.options[:filename]
        data = Document.new(filename).data

        except = @options.options[:except] || []
        @data = Document.new(filename).data.except(*except)

        format = @options.options[:format]
        template_name = File.join __dir__, "../../templates/#{format}.erb"
        template = File.read(template_name)

        # add the json format, if specified
        if format.to_s == "json"
          js = JsonResume.new Document.new(filename)
          @json_resume = js.build
        end

        output = ERB.new(template, trim_mode: "-").result(binding)
        # it is difficult to write readable ERBs with no empty lines...  we use
        # gsub to replace multiple empty lines with \n\n in the final output
        output.gsub!(/([\t ]*\n){3,}/, "\n\n")

        output_filename = output_filename(format)
        backup_and_write(output_filename, output)
        puts "Resume generated and saved to #{output_filename}"

      when :list
        templates = File.join __dir__, "../../templates/*.erb"
        files = Dir.glob(templates).map { |x| "#{File.basename(x)} => #{x}" }
        puts files.join("\n")

      when :cat
        template = @options.options[:template]
        template_path = File.join __dir__, "../../templates/#{template}"
        puts File.read template_path

      when :help
        # nothing to do, OptParser has the context

      when :version
        puts "This is version: #{Resme::VERSION}"

      end
    end
    # rubocop:enable Metrics

    private

    def output_filename(format)
      "resume-#{Date.today.iso8601}.#{format}"
    end

    def backup(filename)
      FileUtils.cp filename, "#{filename}~"
      puts "Backup copy #{filename} created in #{filename}~."
    end

    def backup_and_write(filename, content)
      backup(filename) if File.exist?(filename)
      File.open(filename, "w") { |f| f.puts content }
    end
  end
end
