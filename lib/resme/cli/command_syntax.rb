require 'slop'

module Resme
  module CommandSyntax
    # return a hash with all the commands and their options 
    def self.commands
      h = Hash.new
      self.methods.each do |method|
        if method.to_s.include?("_opts") then
          h = h.merge(eval(method.to_s))
        end
      end
      return h
    end

    private

    def self.version_opts
      opts = Slop::Options.new
      opts.banner = "version -- print version information"
      help = <<EOS
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
      return { :version => [opts, :version, help] }
    end

    def self.console_opts
      opts = Slop::Options.new
      opts.banner = "console [options] -- Enter the console"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION
   Invoke a console, from which you can more easily run
   resme commands.

EXAMPLES
   resme console
   resme:000> 
   resme:001> 
   resme:002>
EOS
       return { :console => [opts, :console, help] } 
    end

    def self.man_opts
      opts = Slop::Options.new
      opts.banner = "man -- print a manual page"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION
   Print the README file of this gem

EXAMPLES
   resme man
EOS
      return { :man => [opts, :man, help] }
    end

    def self.help_opts
      opts = Slop::Options.new
      opts.banner = "help [command] -- print usage string"
      help = <<EOS
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
      return { :help => [opts, :help, help] }
    end

    def self.init_opts
      opts = Slop::Options.new
      opts.banner = "init [-o output_filename]"
      opts.string "-o", "--output", "Output filename"
      opts.boolean "-f", "--force", "Overwrite existing file (if present)"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION

   Generate a YML template for your resume in the current directory.

EXAMPLES
       
   resme init
   resme -o r.yml
   resme -o r.yml --force
EOS
      return { init: [opts, :init, help] }
    end    

    def self.md_opts
      opts = Slop::Options.new
      opts.banner = "md [-o output_filename] file.yml ..."
      opts.string "-o", "--output", "Output filename"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION

   Generate a markdown resume from the YML input files.

EXAMPLES
       
   resme md -o r.md resume.yml
EOS
      return { md: [opts, :md, help] }
    end    

    def self.json_opts
      opts = Slop::Options.new
      opts.banner = "json [-o output_filename] file.yml ..."
      opts.string "-o", "--output", "Output filename"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION

   Generate a JSON resume from the YML input files.

EXAMPLES
       
   resme json -o r.md resume.yml
EOS
      return { json: [opts, :json, help] }
    end

    def self.europass_opts
      opts = Slop::Options.new
      opts.banner = "europass [-o output_filename] file.yml ..."
      opts.string "-o", "--output", "Output filename"
      help = <<EOS
NAME
   #{opts.banner}

SYNOPSYS
   #{opts.to_s}

DESCRIPTION

   Generate a Europass XML resume from the YML input files.

EXAMPLES
       
   resme europass -o r.md resume.yml
EOS
      return { europass: [opts, :europass, help] }
    end 

  end
end
