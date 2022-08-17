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
        reps all_commands, string.split(" ")
        i = i + 1
      end
    end

    # read-eval-print step
    def self.reps(all_commands, argv)
      if argv == [] or argv[0] == "--help" or argv[0] == "-h"
        CommandSemantics.help
        exit 0
      else
        command = argv[0]
        syntax_and_semantics = all_commands[command.to_sym]
        if syntax_and_semantics
          function = syntax_and_semantics[:name]
          opts = syntax_and_semantics[:options]
          
          begin
            parser = Slop::Parser.new(opts)

            result = parser.parse(argv[1..-1])
            options = result.to_hash
            arguments = result.arguments

            eval "CommandSemantics::#{function}(options, arguments)"
          rescue Slop::Error => e
            puts "#{APPNAME}: #{e}"
          rescue Exception => e
            puts e
          end
        else
          puts "#{APPNAME}: "#{command}" is not a valid command. See "#{APPNAME} help""
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
        puts "Error: file #{output} already exists.  Use --force if you want to overwrite it"
      else
        content = File.read(template)
        backup_and_write output, content
        puts "YML resume template generated in #{output}"
      end
    end

    def self.generate(opts, argv)
      format = opts[:to] == "europass" ? "xml" : opts[:to]
      output = opts[:output] || "resume-#{Date.today}.#{format}"
      template = File.join(File.dirname(__FILE__), "/../templates/resume.#{format}.erb")
      if !File.exists?(template)
        puts "Error: format #{format} is not supported."
      end

      render argv, template, output
      puts "Resume generated in #{output}"

      if format == "xml" then
        puts "Europass XML generated. Render via, e.g., http://interop.europass.cedefop.europa.eu/web-services/remote-upload/"
      end
    end

    private

    def self.render(yml_files, template_filename, output_filename)
      data = {}
      yml_files.each do |file|
        data = data.merge(YAML.load_file(file, permitted_classes: [Date]))
      end
      template = File.read(template_filename)
      output = ERB.new(template, trim_mode: "-").result(binding)
      # it is difficult to write readable ERBs with no empty lines...
      # we use gsub to replace multiple empty lines with \n\n in the final output
      output.gsub!(/([\t ]*\n){3,}/, "\n\n")
      backup_and_write output_filename, output
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
