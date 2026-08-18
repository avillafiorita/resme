# frozen_string_literal: true

module Resme
  #
  # Export to JSON resume
  #
  class JsonResume
    include Helper

    def initialize(document)
      @document = document
      @data = document.data
    end

    # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize
    def build
      address = @data[:addresses]&.first || {}
      education = @data[:education].select { |x| x[:publish] } || []

      {
        basics: {
          name: full_name(@data),
          label: @data[:basics][:title],
          image: "",
          email: select(@data[:contacts], label: :email),
          phone: select(@data[:contacts], label: :phone),
          url: select(@data[:web_presence], label: :url),
          summary: @data[:summary],
          location: {
            address: address[:street],
            postalCode: address[:postal_code].to_s,
            city: address[:city],
            countryCode: address[:country_code],
            region: address[:region]
          }.compact,
          profiles: @data[:web_presence].map do |kv|
            {
              network: kv[:label],
              username: kv[:value]
              # url:
            }
          end.compact
        }.compact,

        work: @data[:work].map do |elem|
          {
            name: elem[:name],
            position: elem[:position],
            url: elem[:url],
            startDate: complete_date(elem[:date] || elem[:start_date]),
            endDate: complete_date(elem[:date] || elem[:end_date]),
            summary: elem[:summary],
            highlights: split_highlights(elem[:details])
          }.compact
        end,

        volunteer: (@data[:volunteer] || []).map do |elem|
          {
            organization: elem[:name],
            position: elem[:position],
            startDate: complete_date(elem[:date] || elem[:start_date]),
            endDate: complete_date(elem[:date] || elem[:end_date]),
            summary: elem[:summary],
            highlights: split_highlights(elem[:details])
          }.compact
        end,

        education: education.map do |elem|
          {
            institution: elem[:school],
            url: elem[:url],
            area: elem[:topic],
            studyType: elem[:degree],
            startDate: complete_date(elem[:date] || elem[:start_date]),
            endDate: complete_date(elem[:date] || elem[:end_date]),
            score: elem[:score],
            courses: []
          }.compact
        end,

        awards: (@data[:awards] || []).map do |elem|
          {
            title: elem[:title],
            date: complete_date(elem[:date]),
            awarder: elem[:name],
            summary: elem[:summary]
          }.compact
        end,

        certificates: [],

        publications: (@data[:publications] || []).map do |elem|
          {
            name: [elem[:title], elem[:authors]].compact.join(", "),
            publisher: elem[:publisher],
            releaseDate: complete_date(elem[:date]),
            url: elem[:url],
            summary: ""
          }.compact
        end,

        skills: (@data[:skills] || []).map do |elem|
          {
            name: elem[:name],
            level: elem[:level],
            keywords: split_highlights(elem[:summary])
          }.compact
        end,

        languages: (@data.dig(:languages, :mother_tongues) || []).map do |elem|
          {
            language: elem[:language],
            fluency: "Native speaker"
          }.compact
        end + (@data.dig(:languages, :foreign) || []).map do |elem|
          {
            language: elem[:language],
            fluency: elem[:level]
          }.compact
        end,

        interests: (@data[:interests] || []).map do |elem|
          {
            name: elem[:name],
            keywords: split_highlights(elem[:summary])
          }.compact
        end,

        references: (@data[:references] || []).map do |elem|
          {
            name: elem[:name],
            reference: elem[:reference]
          }.compact
        end,

        projects: (@data[:projects] || []).map do |elem|
          {
            name: elem[:name],
            url: elem[:url],
            startDate: complete_date(elem[:date] || elem[:start_date]),
            endDate: complete_date(elem[:date] || elem[:end_date]),
            description: elem[:summary],
            highlights: []
          }.compact
        end
      }.compact
    end
    # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize


    private

    # make a string with an itemized list into an array of the items
    def split_highlights(highlights)
      (highlights || "").split(/^ *- /)
                        .map { |x| x.gsub("\n", "") }
                        .reject { |x| x == "" }
    end
  end
end
