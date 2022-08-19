#
# Utility functions you might want to use in your ERB
# templates
#

# remove spaces at the beginning of string
# replace extra spaces and special chars with a single space
def clean string
  string.gsub(/^[\t\n ]+/, "").gsub(/[\t\n ]+/, " ")
end

def full_name data
  [data["basics"]["first_name"], data["basics"]["middle_name"], data["basics"]["last_name"]].join(" ")
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
def reflow_to_array string, chars
  if string.length < chars
    return [clean(string)]
  else
    chars.downto(0).each do |index|
      if string[index] == " " or string[index] == "\n" or string[index] == "\t"
        return [clean(string[0..index-1])] + reflow_to_array(string[index+1..-1], chars)
      end
    end
    chars.upto(string.length).each do |index|
      if string[index] == " " or string[index] == "\n" or string[index] == "\t"
        return [clean(string[0..index-1])] + reflow_to_array(string[index+1..-1], chars)
      end
    end
    return [clean(string)]
  end
end

def reflow_to_string string, chars, indentation = ""
  array = reflow_to_array string, chars
  output = ""
  array.each do |line|
    output << indentation + line + "\n"
  end
  output
end

# manage dates of an entry flexibly supporting the following formats:
#
# - from - till (with `from` or `till` possibly partial or empty)
# - date (possibly partial)
#
# abstract dates at the year level, taking care of periods if from and
# till are in two different years
def period entry
  if entry["date"]
    "#{year entry.date}"
  else
    from_year = entry["from"] ? year(entry["from"].to_s) : nil
    till_year = entry["till"] ? year(entry["till"].to_s) : nil

    if from_year && till_year && from_year == till_year
      from_year
    else
      "#{from_year} -- #{till_year ? till_year : "today"}"
    end
  end
end

# make an entry into an item of a list
# - first argument, entry, is a hash containing the symbols specified in header and
#   the following fields: summary and then from, till, or date
# - second argument, header, is an array of symbols, whose values, comma-separated will generate the
#   header line
#
# The output is along the lines of:
#
# - value of key1, value of key2
#   period
#   reflowed summary
def itemize entry, header = ["role", "who", "address"]
<<EOS
- #{clean header.map { |x| entry[x] }.join(", ")}
  #{period entry}
#{reflow_to_string entry["summary"], 72, "  "}
EOS
end

# generate a list of org-mode properties from item and exclude summary from the list
def propertify item, indentation=""
  output = ":PROPERTIES:\n"
  item.each do |k, v|
    if not ["summary", "details"].include? k
      output << ":#{k.upcase}: #{v}\n"
    end
  end
  output << ":END:"
  output.gsub!(/^/, indentation)
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
