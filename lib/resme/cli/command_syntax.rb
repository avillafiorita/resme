require "optparse"

module Resme
  module CommandSyntax
    # Return a hash of hashes.  Each key is the name of a command and
    # includes useful information, such as an Option object to
    # parse options and a documentation string.
    def self.commands
      cmd_spec = {}
      methods.each do |method|
        cmd_spec = cmd_spec.merge eval(method.to_s) if method.to_s.include?("_opts")
      end
      cmd_spec
    end

    def self.version_opts
      opts = OptionParser.new do |opts|
        opts.banner = "version # print version information"
      end
      
      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          return version information

        EXAMPLES
          # resme version
          resme version #{VERSION}
      EOS
      
      {
        version: {
          name: :version,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.console_opts
      opts = OptionParser.new do |opts|
        opts.banner = "console # enter the console"
      end
      
      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Invoke a console, from which you can more easily run
          resme commands.

        EXAMPLES
          resme console
          resme:000> check
          resme:001> generate -t md
          resme:002>
      EOS
      
      {
        console: {
          name: :console,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.man_opts
      opts = OptionParser.new do |opts|
        opts.banner = "man # print resme manual page"
      end
      
      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Print the README file of this gem

        EXAMPLES
          resme man
      EOS
      
      {
        man: {
          name: :man,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.help_opts
      opts = OptionParser.new do |opts|
        opts.banner = "help [command] # print command usage"
      end

      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Print help about a command

        EXAMPLES
          resme help
          resme help generate
      EOS
      {
        help: {
          name: :help,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.init_opts
      opts = OptionParser.new do |opts|
        opts.banner = "init [options] # generate an empty resume.yml file"
        opts.on("-o", "--output FILENAME", String, "Output filename")
        opts.on("-f", "--force", FalseClass, "Overwrite existing file (if present)")
      end
      
      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Generate a YAML template for your resume in the current directory.

        EXAMPLES
          resme init
          resme init -o r.yml
          resme init -o r.yml --force
      EOS
      {
        init: {
          name: :init,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.check_opts
      opts = OptionParser.new do |opts|
        opts.banner = "check resume.yml # Check syntax of resume.yml"
      end

      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Check whether a YAML file conforms with the RESME syntax.

        EXAMPLES
          resme check file.yml
      EOS
      
      {
        check: {
          name: :check,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.list_opts
      opts = OptionParser.new do |opts|
        opts.banner = "list resume.yml # List main sections in resume.yml"
      end

      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          List main sections in resume.yml.

        EXAMPLES
          resme list file.yml
      EOS
      
      {
        list: {
          name: :list,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.view_opts
      opts = OptionParser.new do |o|
        o.banner = "view --template FORMAT # Print template used for format"
        o.on("-t", "--template FORMAT", String, "View template for FORMAT")
      end

      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Print template used for FORMAT

        EXAMPLES
          resme view --template md
      EOS
      
      {
        view: {
          name: :view,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end

    def self.generate_opts
      opts = OptionParser.new do |o|
        o.banner = "generate [options] resume.yml ... # output resume"
        o.on("-e", "--erb FILENAME", String, "Template to use")
        o.on("-t", "--to FORMAT", String, "Output format")
        o.on("-o", "--output FILENAME", String, "Output filename")
        o.on("-s", "--skip SECTION,SECTION", Array, "Sections to skip")
      end

      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Generate a resume from the YAML input files.

        EXAMPLES
          resme generate -t org resume.yml
          resme generate -t md -o r.md section-1.yml section-2.yml
      EOS
      
      {
        generate: {
          name: :generate,
          options: opts,
          help: help.gsub("        ", "")
        }
      }
    end
  end
end
