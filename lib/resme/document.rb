# frozen_string_literal: true

module Resme
  #
  # Wrap the YAML data into a class
  #
  class Document
    attr_reader :filename, :data

    def initialize(filename)
      @filename = filename
      @data = load
    end

    # Access values references by *keys. Keys are Symbols or Strings
    def dig(*keys)
      @data.dig keys.map { |x| x.to_s }
    end

    # Access values references by *keys. Default to "default"
    def fetch(*keys, default)
      dig(*keys) || default
    end

    private

    def load
      begin
        YAML.load_file @filename, permitted_classes: [Date], symbolize_names: true
      rescue Psych::SyntaxError => ex
        puts "#{@filename} has an invalid structure."
        puts ex.message
        exit 1
      end
    end
  end
end
