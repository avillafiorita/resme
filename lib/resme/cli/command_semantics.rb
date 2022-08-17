require "resme/version"
require "readline"
require "fileutils"
require "date"
require "yaml"
require "erb"
require "json"
require "kwalify"

module Resme
  module CommandSemantics
    APPNAME = "resme"
    VERSION = Resme::VERSION

    #
    # Main App Starts Here!
    #
    def self.version(opts = nil, argv = [])
      puts "#{APPNAME} version #{VERSION}"
    end

    def self.man(opts = nil, argv = [])
      path = File.join(File.dirname(__FILE__), "/../../../README.org")
      file = File.open(path, "r")
      puts file.read
    end

    def self.help(opts = nil, argv = [])
      all_commands = CommandSyntax.commands
      
      if argv != []
        argv.map do |x|
          puts all_commands[x.to_sym][:help]
          puts "\n\n"
        end
      else
        puts "#{APPNAME} command [options] [args]\n"
        puts "Available commands:\n"
        all_commands.each_key do |key|
          puts "  #{all_commands[key][:options].banner}"
        end
      end
    end

    def self.console(opts, argv = [])
      all_commands = CommandSyntax.commands
      all_commands.delete(:console)
      
      i = 0
      while true
        string = Readline.readline("#{APPNAME}:%03d> " % i, true)
        # as a courtesy, remove any leading appname string
        string.gsub!(/^#{APPNAME} /, "")
        exit 0 if %w[exit quit .].include? string
        execute all_commands, string.split(" ")
        i = i + 1
      end
    end

    # read-eval-print step
    # check if argv is in any of all_commands, parse options
    # according to the specification in all_commands and invoke
    # a function in this class to actually do the work
    def self.execute(all_commands, argv)
      if argv == [] or argv[0] == "--help" or argv[0] == "-h"
        help
        exit 0
      else
        command = argv[0]
        command_spec = all_commands[command.to_sym]

        if command_spec
          command_name = command_spec[:name]
          option_parser = command_spec[:options]

          begin
            argv.shift # remove command name from ARGV
            options = {}
            parser = option_parser.parse!(into: options)
            eval "CommandSemantics::#{command_name}(options, argv)"
          rescue Exception => e
            puts "#{APPNAME} error: #{e}"
            puts "Help with \"#{APPNAME} help #{command_name}\""
          end
        else
          puts "#{APPNAME} error: "#{command}" is not a valid command."
          puts "List commands with \"#{APPNAME} help\"."
        end
      end
    end

    #
    # APP SPECIFIC COMMANDS
    #
    def self.check(opts, argv)
      path = File.join(File.dirname(__FILE__), "/../templates/schema.yml")
      schema = Kwalify::Yaml.load_file(path)

      # create validator
      validator = Kwalify::Validator.new(schema)
      # load document
      document = Kwalify::Yaml.load_file(argv[0])
      # validate
      errors = validator.validate(document)

      # show errors
      if errors && !errors.empty?
        for e in errors
          puts "[#{e.path}] #{e.message}"
        end
      else
        puts "The file #{argv[0]} validates."
      end
    end

    def self.init(opts, argv)
      output = opts[:output] || "resume.yml"
      force = opts[:force]
      path = File.dirname(__FILE__), "/../templates/resume.yml"
      template = File.join(path)

      # avoid catastrophe
      if File.exist?(output) && !force
        puts "#{APPNAME} error: file #{output} already exists."
        puts "Use --force if you want to overwrite it."
      else
        content = File.read(template)
        backup_and_write output, content
        puts "YML resume template generated in #{output}"
      end
    end

    def self.list(opts, argv)
      data = {}
      argv.each do |file|
        data = data.merge(YAML.load_file(file, permitted_classes: [Date]))
      end
      puts "Sections included in #{argv.join(", ")}:"
      data.keys.each do |key|
        puts "- #{key}: #{(data[key] || []).size} entries"
      end
    end

    def self.generate(opts, argv)
      format = opts[:to] == "europass" ? "xml" : opts[:to]
      output = opts[:output] || "resume-#{Date.today}.#{format}"

      if opts[:erb]
        template = opts[:erb]
      else
        template = File.join(File.dirname(__FILE__), "/../templates/resume.#{format}.erb")
      end

      skipped_sections = opts[:skip] || []

      if !File.exists?(template)
        puts "#{APPNAME} error: format #{format} is not understood."
      end

      render argv, template, output, skipped_sections
      puts "Resume generated in #{output}"

      if format == "xml" then
        puts "Europass XML generated. Render via, e.g., http://interop.europass.cedefop.europa.eu/web-services/remote-upload/"
      end
    end

    private

    def self.render(yml_files, template_name, output_name, skipped_sections)
      data = {}
      yml_files.each do |file|
        data = data.merge(YAML.load_file(file, permitted_classes: [Date]))
      end
      skipped_sections.each do |section|
        data.reject! { |k| k == section } 
      end
      template = File.read(template_name)
      output = ERB.new(template, trim_mode: "-").result(binding)
      # it is difficult to write readable ERBs with no empty lines...
      # we use gsub to replace multiple empty lines with \n\n in the final output
      output.gsub!(/([\t ]*\n){3,}/, "\n\n")
      backup_and_write output_name, output
    end

    def self.backup(filename)
      FileUtils::cp filename, filename + "~"
      puts "Backup copy #{filename} created in #{filename}~."
    end

    def self.backup_and_write(filename, content)
      backup(filename) if File.exist?(filename)
      File.open(filename, "w") { |f| f.puts content }
    end
  end
end
