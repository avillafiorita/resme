require "slop"

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
      opts = Slop::Options.new
      opts.banner = "version -- print version information"
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
      opts = Slop::Options.new
      opts.banner = "console [options] -- Enter the console"
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
      opts = Slop::Options.new
      opts.banner = "man -- print a manual page"
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
      opts = Slop::Options.new
      opts.banner = "help [command] -- print usage string"
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
      opts = Slop::Options.new
      opts.banner = "init [-o output_filename]"
      opts.string "-o", "--output", "Output filename"
      opts.boolean "-f", "--force", "Overwrite existing file (if present)"
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
      opts = Slop::Options.new
      opts.banner = "check -- Check if file conforms with RESME syntax"
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

    def self.generate_opts
      opts = Slop::Options.new
      opts.banner = "generate [-t format] [-o output_filename] file.yml ..."
      opts.string "-t", "--to", "Output format (one of md, org, json, europass)"
      opts.string "-o", "--output", "Output filename"
      help = <<-EOS
        NAME
          #{opts.banner}

        SYNOPSYS
          #{opts.to_s}

        DESCRIPTION
          Generate a resume from the YAML input files.

        EXAMPLES
          resme generate -t org -o r.org resume.yml
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
