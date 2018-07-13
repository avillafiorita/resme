#
# Utility functions you might want to use in your ERB
# template
#

# remove spaces at the beginning of string
# remove extra spaces and special chars with a single space
def clean string
  string.gsub(/^[\t\n ]+/, "").gsub(/[\t\n ]+/, " ")
end

# break a string into substrings of length chars breaking at spaces
# and newlines
#
# * `string` string to reflow
# * `chars` number of characters to break the string at
# * returns an array of strings of length < chars (with exceptions
#   for special cases)
#
# special cases: if one line is longer than chars characters, then
# break at the first space after chars
#
def reflow string, chars
  if string.length < chars
    return [clean(string)]
  else
    chars.downto(0).each do |index|
      if string[index] == " " or string[index] == "\n" or string[index] == "\t"
        return [clean(string[0..index-1])] + reflow(string[index+1..-1], chars)
      end
    end
    chars.upto(string.length).each do |index|
      if string[index] == " " or string[index] == "\n" or string[index] == "\t"
        return [clean(string[0..index-1])] + reflow(string[index+1..-1], chars)
      end
    end
    return [clean(string)]
  end
end

# Utility function for managing dates (2015-01-01) and partial dates (2015-05)
def year string
  string.to_s[0..3]
end

def month string
  string.to_s[5..6]
end

def day string
  string.to_s[8..9]
end
 
def has_month input
  if input.class == Date
    true
  else
    input.size >= 7
  end
end

def has_day input
  if input.class == Date
    true
  else
    input.size == 10
  end
end

# Access hash keys like they were class methods
# hash["key"] -> hash.key
class Hash
  def method_missing(m)
    key = m.to_s

    # error: nil value
    if self.has_key? key and self[key] == nil
      $stderr.puts "WARNING!! The value of key '#{key}' is nil."

      # we put a bit of info about the top level structure of a resume to avoid extra-long error messages
      # I don't want to print detailed information about top-level entries missing in the resume
      top_level_entries = [
        "contacts", "addresses", "web_presence", "summary", "work", "teaching", "projects", "other",
        "committees", "volunteer", "visits", "education", "publications", "talks", "awards", "achievements",
        "software", "skills", "languages", "driving", "interests", "references"]
      if not top_level_entries.include?(key) then
        $stderr.puts "Offending entry:"
        # $stderr.puts self.to_s
        self.keys.each do |k|
          $stderr.puts "\t#{k}: #{self[k]}"
        end
        $stderr.puts ""
      end
    end

    return self[key] if self.has_key? key

    # we get here if the key is not found
    # we report an error, return "" and continue
    # the actual mileage might vary

    # more error reporting: key not found
    $stderr.puts "ERROR!! Key '#{key}' not found in the following entry."
    # $stderr.puts self.to_s
    self.keys.each do |k|
      $stderr.puts "  #{k}: #{self[k]}"
    end
    $stderr.puts ""

    return ""
  end
end

