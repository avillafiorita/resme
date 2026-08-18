# frozen_string_literal: true

module Resme
  #
  # Validate a document
  #
  class DocumentValidator
    def initialize(document)
      @document = document
    end

    def validate
      begin
        errors = []
        ClassyHash.validate(
          @document.data,
          SCHEMA,
          errors: errors,
          strict: true,
          raise_errors: true,
          full: true
        )
        errors
      rescue Exception => ex
        puts "#{@document.filename} does not validate:"
        ex.entries.each do |error|
          puts "- #{error[:full_path]}: #{error[:message]}"
        end
      end
    end

    OPTIONAL_STRING = [:optional, String, NilClass]
    OPTIONAL_PARTIAL_DATE = [:optional, Date, String, Integer, NilClass]
    PARTIAL_DATE = [Date, String, Integer]

    #
    # This defines the structure of resume.yml
    # We validate it with ClassyHash
    #
    SCHEMA = {
      basics: {
        first_name: String,
        middle_name: OPTIONAL_STRING,
        last_name: String,
        title: OPTIONAL_STRING,
        picture: OPTIONAL_STRING,
        birthdate: [:optional, Date, NilClass],
        nationality: OPTIONAL_STRING,
        marital_status: OPTIONAL_STRING,
        gender: OPTIONAL_STRING
      },
      contacts: [[ { label: String, value: String } ]],
      addresses: [[
                    {
                      label: String,
                      street: OPTIONAL_STRING,
                      postal_code: [:optional, String, Integer, NilClass],
                      city: OPTIONAL_STRING,
                      region: OPTIONAL_STRING,
                      country_code: OPTIONAL_STRING,
                      country: OPTIONAL_STRING
                    }
                  ]],
      web_presence: [:optional,
                     [[
                        {
                          label: String,             
                          value: String
                        },
                      ]],
                     NilClass
                    ],
      summary: OPTIONAL_STRING,
      work: [:optional,
             [[
                {
                  name: OPTIONAL_STRING,
                  url: OPTIONAL_STRING,
                  address: OPTIONAL_STRING,
                  end_date: OPTIONAL_PARTIAL_DATE,
                  start_date: OPTIONAL_PARTIAL_DATE,
                  position: String,
                  summary: String,
                  details: OPTIONAL_STRING
                },
              ]],
             NilClass
            ],
      teaching: [:optional,
                 [[
                    {
                      name: String,
                      school: OPTIONAL_STRING,
                      address: OPTIONAL_STRING,
                      end_date: OPTIONAL_PARTIAL_DATE,
                      start_date: OPTIONAL_PARTIAL_DATE,
                      position: String,
                      subject: String,
                      summary: OPTIONAL_STRING,
                      details: OPTIONAL_STRING
                    }
                  ]],
                 NilClass
                ],
      projects: [:optional,
                 [[
                    {
                      name: String,
                      size: OPTIONAL_STRING,
                      stakeholder: OPTIONAL_STRING,
                      end_date: OPTIONAL_PARTIAL_DATE,
                      start_date: OPTIONAL_PARTIAL_DATE,
                      position: String,
                      summary: OPTIONAL_STRING,
                    }
                  ]],
                 NilClass
                ],
      other: [:optional,
              [[
                 {
                   name: OPTIONAL_STRING,
                   end_date: OPTIONAL_PARTIAL_DATE,
                   start_date: OPTIONAL_PARTIAL_DATE,
                   position: String,
                   summary: OPTIONAL_STRING,
                 }
               ]],
              NilClass
             ],
      committees: [:optional,
                   [[
                      {
                        name: String,
                        position: String,
                        editions: [String, Integer],
                        url: OPTIONAL_STRING,
                      }
                    ]],
                   NilClass
                  ],
      volunteer: [:optional,
                  [[
                     {
                       name: String,
                       where: OPTIONAL_STRING,
                       date: OPTIONAL_PARTIAL_DATE,
                       end_date: OPTIONAL_PARTIAL_DATE,
                       start_date: OPTIONAL_PARTIAL_DATE,
                       position: String,
                       summary: OPTIONAL_STRING,
                     }
                   ]],
                  NilClass
                 ],
      visits: [:optional,
               [[
                  {
                    name: String,
                    address: OPTIONAL_STRING,
                    end_date: OPTIONAL_PARTIAL_DATE,
                    start_date: OPTIONAL_PARTIAL_DATE,
                    position: String,
                    summary: OPTIONAL_STRING,
                  }
                ]],
               NilClass
              ],
      education: [:optional,
                  [[
                     {
                       degree: OPTIONAL_STRING,
                       topic: OPTIONAL_STRING,
                       school: String,
                       address: OPTIONAL_STRING,
                       date: OPTIONAL_PARTIAL_DATE,
                       end_date: OPTIONAL_PARTIAL_DATE,
                       start_date: OPTIONAL_PARTIAL_DATE,
                       url: OPTIONAL_STRING,
                       publish: TrueClass,
                       score: [:optional, String, Integer, NilClass],
                     }
                   ]],
                  NilClass
                 ],
      publications: [:optional,
                     [[
                        {
                          title: String,
                          authors: String,
                          publisher: String,
                          date: PARTIAL_DATE,
                          url: OPTIONAL_STRING,
                        }
                      ]],
                     NilClass
                    ],
      talks: [:optional,
              [[
                 {
                   title: String,
                   venue: String,
                   date: PARTIAL_DATE,
                   url: OPTIONAL_STRING,
                 }
               ]],
              NilClass
             ],
      awards: [:optional,
               [[
                  {
                    name: String,
                    address: OPTIONAL_STRING,
                    date: PARTIAL_DATE,
                    title: String,
                    summary: OPTIONAL_STRING
                  }
                ]],
               NilClass
              ],
      achievements: [:optional,
                     [[
                        {
                          name: String,
                          address: OPTIONAL_STRING,
                          date: OPTIONAL_PARTIAL_DATE,
                          title: String,
                          summary: OPTIONAL_STRING
                        }
                      ]],
                     NilClass
                    ],
      software: [:optional,
                 [[
                    {
                      title: String,
                      url: OPTIONAL_STRING,
                      programming_language: OPTIONAL_STRING,
                      license: OPTIONAL_STRING,
                      position: OPTIONAL_STRING,
                      summary: OPTIONAL_STRING,
                    }
                  ]],
                 NilClass
                ],
      skills: [:optional,
               [[
                  {
                    name: String,
                    level: OPTIONAL_STRING,
                    summary: OPTIONAL_STRING,
                  }
                ]],
               NilClass
              ],
      driving: [:optional,
                [[ { license: String, } ]],
                NilClass
               ],
      languages: [:optional,
                  {
                    mother_tongues: [[
                                       {
                                         code: OPTIONAL_STRING,
                                         language: String,
                                       }
                                     ]],
                    foreign: [:optional,
                              [[
                                 {
                                   code: OPTIONAL_STRING,
                                   language: String,
                                   level: OPTIONAL_STRING,
                                   listening: OPTIONAL_STRING,
                                   reading: OPTIONAL_STRING,
                                   spoken_interaction: OPTIONAL_STRING,
                                   spoken_production: OPTIONAL_STRING,
                                   writing:  OPTIONAL_STRING
                                 }
                               ]],
                              NilClass
                             ]
                  },
                  NilClass
                 ],
      interests: [:optional,
                  [[
                     {
                       name: String,
                       level: OPTIONAL_STRING,
                       summary: OPTIONAL_STRING,
                     }
                   ]],
                  NilClass
                 ],
      references: [:optional,
                   [[
                      {
                        name: String,
                        reference: String,
                        contacts: [[ {label: String, value: String} ]]
                      }
                    ]],
                   NilClass
                  ]
    }
  end
end
