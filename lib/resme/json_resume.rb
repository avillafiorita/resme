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

    def build
      address = @data[:addresses]&.first || {}
      
      {
        "basics": {
          "name": full_name(@data),
          "label": @data[:basics][:title],
          "image": "",
          "email": select(@data[:contacts], label: :email),
          "phone": select(@data[:contacts], label: :phone),
          "url": select(@data[:web_presence], label: :url),
          "summary": @data[:summary],
          "location": {
            "address": address[:street],
            "postalCode": address[:postal_code].to_s,
            "city": address[:city],
            "countryCode": address[:country_code],
            "region": address[:region]
          }.compact,
          "profiles": @data[:web_presence].map do |kv|
            {
              "network": kv[:label],
              "username": kv[:value],
              # "url":
            }
          end.compact
        }.compact,

        "work": @data[:work].map do |job|
          {
            "name": job[:name],
            "position": job[:position],
            "url": job[:url],
            "startDate": complete_date(job[:date] || job[:start_date]),
            "endDate": complete_date(job[:date] || job[:end_date]),
            "summary": job[:summary],
            "highlights": split_highlights(job[:details])
          }.compact
        end,

        "volunteer": (@data[:volunteer] || []).map do |job|
          {
            "organization": job[:name],
            "position": job[:position],
            "startDate": complete_date(job[:date] || job[:start_date]),
            "endDate": complete_date(job[:date] || job[:end_date]),
            "summary": job[:summary],
            "highlights": split_highlights(job[:details])
          }.compact
        end,

        "education": (@data[:education].select { |x| x[:publish] } || []).map do |job|
          {
            "institution": job[:school],
            "url": job[:url],
            "area": job[:topic],
            "studyType": job[:degree],
            "startDate": complete_date(job[:date] || job[:start_date]),
            "endDate": complete_date(job[:date] || job[:end_date]),
            "score": job[:score],
            "courses": []
          }.compact
        end,

        "awards": (@data[:awards] || []).map do |job|
          {
            "title": job[:title],
            "date": complete_date(job[:date]),
            "awarder": job[:name],
            "summary": job[:summary]
          }.compact
        end,

        "certificates": [],

        "publications": (@data[:publications] || []).map do |job|
          {
            "name": [job[:title], job[:authors]].compact.join(", "),
            "publisher": job[:publisher],
            "releaseDate": complete_date(job[:date]),
            "url": job[:url],
            "summary": ""
          }.compact
        end,
        
        "skills": (@data[:skills] || []).map do |job|
          {
            "name": job[:name],
            "level": job[:level],
            "keywords": split_highlights(job[:summary])
          }.compact
        end,
        
        "languages": (@data.dig(:languages, :mother_tongues) || []).map do |job|
          { 
            "language": job[:language],
            "fluency": "Native speaker"
          }.compact
        end + (@data.dig(:languages, :foreign) || []).map do |job|
          { 
            "language": job[:language],
            "fluency": job[:level]
          }.compact
        end,

        "interests": (@data[:interests] || []).map do |job|
          {
            "name": job[:name],
            "keywords": split_highlights(job[:summary])
          }.compact
        end,
        
        "references": (@data[:references] || []).map do |job|
          {
            "name": job[:name],
            "reference": job[:reference]
          }.compact
        end,
        
        "projects": (@data[:projects] || []).map do |job|
          {
            "name": job[:name],
            "url": job[:url],
            "startDate": complete_date(job[:date] || job[:start_date]),
            "endDate": complete_date(job[:date] || job[:end_date]),
            "description": job[:summary],
            "highlights": []
          }.compact
        end
      }.compact
    end

    private

    # make a string with an itemized list into an array of the items
    def split_highlights(highlights)
      (highlights || "").split(/^ *- /)
        .map { |x| x.gsub("\n", "") }
        .reject { |x| x == "" }
    end
  end
end
