# frozen_string_literal: true

module Resme
  #
  # Helper functions for renderers
  #
  module Helper
    # Strip and replace extra spaces and special chars with a single space
    def clean(string)
      string.strip.gsub(/[\t\n ]+/, " ")
    end

    def full_name(data)
      [
        data.dig(:basics, :first_name),
        data.dig(:basics, :middle_name),
        data.dig(:basics, :last_name),
      ].compact.join(" ")
    end

    # Break a string into substrings of length chars breaking at spaces
    # and newlines
    #
    # - `string` string to reflow
    # - `chars` number of characters to break the string at
    #
    # Returns an array of strings of length < chars (with exceptions for special
    # cases).
    #
    # Special cases: if one line is longer than chars characters, then break at
    # the first space after chars
    #
    # rubocop:disable Metrics/AbcSize
    def reflow_a(string, line_break: 78)
      # if the string is less than line_break chars, we are done
      return [clean(string)] if string.length < line_break

      # here the string is longer than line_break chars
      #
      # if the string has a space between 0 and line_break, we break the
      # string and apply recursion
      #
      line_break.downto(0).each do |index|
        if blank?(string[index])
          return [clean(string[0..(index - 1)])] +
                 reflow_a(string[(index + 1)..], line_break:)
        end
      end

      # here the string does not have a space between 0 and line_break
      #
      # In this case we try to break at the first blank after the string and
      # apply recursion
      #
      line_break.upto(string.length).each do |index|
        if blank?(string[index])
          return [clean(string[0..(index - 1)])] +
                 reflow_a(string[(index + 1)..], line_break:)
        end
      end

      # here string is longer than line_break and it does not have spaces
      #
      # The only thing left to do is returning the string as it is
      #
      [clean(string)]
    end
    # rubocop:enable Metrics/AbcSize

    def blank?(char)
      [" ", "\t", "\n"].include?(char)
    end

    # Reflow at +line_break+, returning a string with each line delimited by
    # +delimiter+ (by default newline) and indented with +indent+ spaces.
    #
    def reflow_s(string, line_break: 75, delimiter: "\n", indent: 3)
      indentation = " " * indent

      # remember PARAGRAPH BREAKS
      paragraphs = string.gsub("\n\n", "{{PBREAK}}").split("{{PBREAK}}")

      formatted_pars = paragraphs.map do |paragraph|
        reflow_a(paragraph, line_break:).join(delimiter).gsub(/^/, indentation)
      end

      formatted_pars.join("\n\n") + "\n"
    end

    # Return a string encoding a period (start - end) from a Hash, containing
    # the specificatio of the period.  Manage special cases (partial dates,
    # optional dates).
    #
    # Entry is the input Hash, +from+ is the digging specification to get the
    # "start" date, +to+ is the digging specification to get the "end" date.
    # Fallback is a key we use if +from+ or +to+ are not present.
    # All accept a Symbol or an Array.
    #
    # abstract dates at the year level, taking care of periods if from and
    # till are in two different years
    #
    def period(entry, date: :date, from: :start_date, to: :end_date, separator: "--")
      date = entry[date]

      return format_date(date) if date.is_a?(Date)

      from = entry.dig(*[from].flatten)
      to = entry.dig(*[to].flatten)

      [format_date(from), separator, format_date(to)].compact.join(" ")
    end

    # make an entry into an itemized list
    #
    # - +entry+ is a hash containing the specification of a position to itemize
    #   (e.g., a work period, a degree, ...)
    #
    # - +header+, is an array of symbols, whose values, comma-separated will
    #   generate the header line
    #
    # The output is a String along the lines of:
    #
    # - value of key1, value of key2
    #   period
    #   reflowed summary
    #
    def itemize(entry, header: %i[role who address], summary_key: :summary)
      header = clean header.map { |x| entry[x] }.compact.join(", ")

      %(- #{header}
          #{period entry}
          #{reflow_to_s entry[summary_key], line_break: 72, indent: 2}
       ).gsub(/^          /, "")
    end

    # Make a Hash into a list of properties, optionally excluding some keys
    # specified in +except:+ (by default +summary+ and +details+)
    def propertify(entry, except: %i[summary details], indent: 3)
      indentation = " " * indent

      head = ":PROPERTIES:"
      body = entry.except(*except).map { |k, v| ":#{k.upcase}: #{v}" }.join("\n")
      tail = ":END:"

      "#{head}\n#{body}\n#{tail}\n".gsub!(/^/, indentation)
    end

    def select(contacts, label: :email)
      contact = (contacts || []).find { |x| x[:label] == label.to_s }
      contact ? contact[:value] : nil
    end

    #
    # Utility functions for managing dates in the form 2015-01-01 and partial
    # dates (e.g., 2015-05, 2015)
    #

    # Format the input as a date, according to format.  If the input is not
    # a date, return it as it (assuming it represents a partial date (e.g.,
    # 2012-01, 2012
    #
    # Special case of an empty date (date == nil) returns ""
    #
    def format_date(date, format: "%Y-%m-%d")
      date.is_a?(Date) ? date.strftime(format) : date.to_s
    end

    def complete_date(incomplete_date, format: "%Y-%m-%d")
      return incomplete_date.strftime(format) if incomplete_date.is_a?(Date)

      if ymd?(incomplete_date.to_s)
        incomplete_date.to_s
      elsif ym?(incomplete_date.to_s)
        "#{incomplete_date}-01"
      elsif y?(incomplete_date.to_s)
        "#{incomplete_date}-01-01"
      end
    end

    # Return the year
    def year(input)
      input.is_a?(Date) ? input.strftime("%Y") : input.to_s[0..3]
    end

    # Return the month
    def month(input)
      input.is_a?(Date) ? input.strftime("%m") : input.to_s[5..6]
    end

    # Return the day
    def day(input)
      input.is_a?(Date) ? input.strftime("%d") : input.to_s[8..9]
    end

    # Is the input in the form YYYY-MM(-..)
    def y?(input)
      input.is_a?(Date) || input.to_s.size == 4
    end

    # Is the input in the form YYYY-MM(-..)
    def ym?(input)
      input.is_a?(Date) || input.to_s.size == 7
    end

    # Is the input in the form YYYY-MM-DD
    def ymd?(input)
      input.is_a?(Date) || input.to_s.size == 10
    end
  end
end
