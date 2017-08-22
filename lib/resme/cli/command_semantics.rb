require 'resme/version'
require 'readline'
require 'fileutils'
require 'date'
require 'yaml'
require 'erb'

module Resme
  module CommandSemantics
    APPNAME = 'resme'
    VERSION = Resme::VERSION

    #
    # Main App Starts Here!
    #
    def self.version opts = nil, argv = []
      puts "#{APPNAME} version #{VERSION}"
    end

    def self.man opts = nil, argv = []
      path = File.join(File.dirname(__FILE__), "/../../../README.md")
      file = File.open(path, "r")
      contents = file.read
      puts contents
    end

    def self.help opts = nil, argv = []
      all_commands = CommandSyntax.commands
      
      if argv != []
        argv.map { |x| puts all_commands[x.to_sym][2] }
      else
        puts "#{APPNAME} command [options] [args]"
        puts ""
        puts "Available commands:"
        puts ""
        all_commands.keys.each do |key|
          puts "  " + all_commands[key][0].banner
        end
      end
    end

    def self.console opts, argv = []
      all_commands = CommandSyntax.commands
      all_commands.delete(:console)
      
      i = 0
      while true
        string = Readline.readline("#{APPNAME}:%03d> " % i, true)
        string.gsub!(/^#{APPNAME} /, "") # as a courtesy, remove any leading appname string
        if string == "exit" or string == "quit" or string == "." then
          exit 0
        end
        reps all_commands, string.split(' ')
        i = i + 1
      end
    end

    # read-eval-print step
    def self.reps all_commands, argv
      if argv == [] or argv[0] == "--help" or argv[0] == "-h"
        CommandSemantics.help
        exit 0
      else
        command = argv[0]
        syntax_and_semantics = all_commands[command.to_sym]
        if syntax_and_semantics
          opts = syntax_and_semantics[0]
          function = syntax_and_semantics[1]
          
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
          puts "#{APPNAME}: '#{command}' is not a valid command. See '#{APPNAME} help'"
        end
      end
    end

    #
    # APP SPECIFIC COMMANDS
    #
    def self.init opts, argv
      output = opts[:output] || "resume.yml"
      force = opts[:force]
      template = File.join(File.dirname(__FILE__), "/../templates/resume.yml")

      # avoid catastrophy
      if File.exist?(output) and not force
        puts "Error: file #{output} already exists.  Use --force if you want to overwrite it"
      else
        content = File.read(template)
        backup_and_write output, content
        puts "YML resume template generated in #{output}"
      end
    end

    def self.md opts, argv
      output = opts[:output] || "resume-#{Date.today}.md"
      template = File.join(File.dirname(__FILE__), "/../templates/resume.md.erb")

      render argv, template, output
      puts "Resume generated in #{output}"
    end

    def self.json opts, argv
      output = opts[:output] || "resume-#{Date.today}.json"
      template = File.join(File.dirname(__FILE__), "/../templates/resume.json.erb")

      render argv, template, output
      puts "Resume generated in #{output}"
    end

    def self.europass opts, argv
      output = opts[:output] || "resume-#{Date.today}.xml"
      template = File.join(File.dirname(__FILE__), "/../templates/europass/eu.xml.erb")

      render argv, template, output
      puts "Resume generated in #{output}"
      puts "Render via, e.g., http://interop.europass.cedefop.europa.eu/web-services/remote-upload/"
    end

    private

    def self.render yml_files, template_filename, output_filename
      data = Hash.new
      yml_files.each do |file|
        data = data.merge(YAML.load_file(file))
      end
      template = File.read(template_filename)
      output = ERB.new(template).result(binding)
      backup_and_write output_filename, output
    end

    def self.backup filename
      FileUtils::cp filename, filename + "~"
      puts "Backup copy #{filename} created in #{filename}~."
    end

    def self.backup_and_write filename, content
      backup(filename) if File.exist?(filename)
      File.open(filename, "w") { |f| f.puts content }
    end
  end
end
