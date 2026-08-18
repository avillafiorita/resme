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

    private

    def load
      YAML.load_file @filename, permitted_classes: [Date], symbolize_names: true
    rescue Psych::SyntaxError => e
      puts "#{@filename} has an invalid structure."
      puts e.message
      exit 1
    end
  end
end
