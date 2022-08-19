require "classy_hash"
require "date"

module Resme
  module ResumeStructureValidator
    OPTIONAL_STRING = [:optional, String, NilClass]
    OPTIONAL_PARTIAL_DATE = [:optional, Date, String, Integer, NilClass]
    PARTIAL_DATE = [Date, String, Integer]

    def self.validate(loaded_yaml)
      errors = []
      ClassyHash.validate(
        loaded_yaml,
        SCHEMA,
        errors: errors,
        strict: true,
        raise_errors: true,
        full: true
      )
      errors
    end

    #
    # This defines the structure of resume.yml
    # We validate it with ClassyHash
    #
    SCHEMA = {
      "basics" => {
        "first_name" => String,
        "middle_name" => OPTIONAL_STRING,
        "last_name" => String,
        "title" => OPTIONAL_STRING,
        "picture" => OPTIONAL_STRING,
        "birthdate" => [:optional, Date, NilClass],
        "nationality" => OPTIONAL_STRING,
        "marital_status" => OPTIONAL_STRING,
        "gender" => OPTIONAL_STRING
      },
      "contacts" => [[ {
                         "label" => String, 
                         "value" => String 
                       } ]],
      "addresses" => [[ {
                          "label" => String,
                          "street" => OPTIONAL_STRING,
                          "zip_code" => [:optional, String, Integer, NilClass],
                          "city" => OPTIONAL_STRING,
                          "country" => OPTIONAL_STRING
                        } ]],
      "web_presence" => [:optional,
                         [[
                            {
                              "label" => String,                         
                              "value" => String
                            },
                          ]],
                         NilClass
                        ],
      "summary" => OPTIONAL_STRING,
      "work" => [:optional,
                 [[
                    {
                      "who" => OPTIONAL_STRING,
                      "website" => OPTIONAL_STRING,
                      "address" => OPTIONAL_STRING,
                      "till" => OPTIONAL_PARTIAL_DATE,
                      "from" => OPTIONAL_PARTIAL_DATE,
                      "role" => String,
                      "summary" => String,
                      "details" => OPTIONAL_STRING
                    },
                  ]],
                 NilClass
                ],
      "teaching" => [:optional,
                     [[
                        {
                          "who" => String,
                          "school" => OPTIONAL_STRING,
                          "address" => OPTIONAL_STRING,
                          "till" => OPTIONAL_PARTIAL_DATE,
                          "from" => OPTIONAL_PARTIAL_DATE,
                          "role" => String,
                          "subject" => String,
                          "summary" => OPTIONAL_STRING,
                          "details" => OPTIONAL_STRING
                        }
                      ]],
                     NilClass
                    ],
      "projects" => [:optional,
                     [[
                        {
                          "name" => String,
                          "size" => OPTIONAL_STRING,
                          "who" => OPTIONAL_STRING,
                          "till" => OPTIONAL_PARTIAL_DATE,
                          "from" => OPTIONAL_PARTIAL_DATE,
                          "role" => String,
                          "summary" => OPTIONAL_STRING,
                        }
                      ]],
                     NilClass
                    ],
      "other" => [:optional,
                  [[
                     {
                       "who" => OPTIONAL_STRING,
                       "till" => OPTIONAL_PARTIAL_DATE,
                       "from" => OPTIONAL_PARTIAL_DATE,
                       "role" => String,
                       "summary" => OPTIONAL_STRING,
                     }
                   ]],
                  NilClass
                 ],
      "committees" => [:optional,
                       [[
                          {
                            "who" => String,
                            "role" => String,
                            "editions" => [String, Integer],
                            "url" => OPTIONAL_STRING,
                          }
                        ]],
                       NilClass
                      ],
      "volunteer" => [:optional,
                      [[
                         {
                           "who" => String,
                           "where" => OPTIONAL_STRING,
                           "date" => OPTIONAL_PARTIAL_DATE,
                           "till" => OPTIONAL_PARTIAL_DATE,
                           "from" => OPTIONAL_PARTIAL_DATE,
                           "role" => String,
                           "summary" => OPTIONAL_STRING,
                         }
                       ]],
                      NilClass
                     ],
      "visits" => [:optional,
                   [[
                      {
                        "who" => String,
                        "address" => OPTIONAL_STRING,
                        "till" => OPTIONAL_PARTIAL_DATE,
                        "from" => OPTIONAL_PARTIAL_DATE,
                        "role" => String,
                        "summary" => OPTIONAL_STRING,
                      }
                    ]],
                   NilClass
                  ],
      "education" => [:optional,
                      [[
                         {
                           "degree" => OPTIONAL_STRING,
                           "topic" => OPTIONAL_STRING,
                           "school" => String,
                           "address" => OPTIONAL_STRING,
                           "date" => OPTIONAL_PARTIAL_DATE,
                           "till" => OPTIONAL_PARTIAL_DATE,
                           "from" => OPTIONAL_PARTIAL_DATE,
                           "publish" => TrueClass,
                           "score" => [:optional, String, Integer, NilClass],
                         }
                       ]],
                      NilClass
                     ],
      "publications" => [:optional,
                         [[
                            {
                              "title" => String,
                              "authors" => String,
                              "publisher" => String,
                              "date" => PARTIAL_DATE,
                              "url" => OPTIONAL_STRING,
                            }
                          ]],
                         NilClass
                        ],
      "talks" => [:optional,
                  [[
                     {
                       "title" => String,
                       "venue" => String,
                       "date" => PARTIAL_DATE,
                       "url" => OPTIONAL_STRING,
                     }
                   ]],
                  NilClass
                 ],
      "awards" => [:optional,
                   [[
                      {
                        "who" => String,
                        "address" => OPTIONAL_STRING,
                        "date" => PARTIAL_DATE,
                        "title" => String,
                        "summary" => OPTIONAL_STRING
                      }
                    ]],
                   NilClass
                  ],
      "achievements" => [:optional,
                         [[
                            {
                              "who" => String,
                              "address" => OPTIONAL_STRING,
                              "date" => OPTIONAL_PARTIAL_DATE,
                              "title" => String,
                              "summary" => OPTIONAL_STRING
                            }
                          ]],
                         NilClass
                        ],
      "software" => [:optional,
                     [[
                        {
                          "title" => String,
                          "url" => OPTIONAL_STRING,
                          "programming_language" => OPTIONAL_STRING,
                          "license" => OPTIONAL_STRING,
                          "role" => OPTIONAL_STRING,
                          "summary" => OPTIONAL_STRING,
                        }
                      ]],
                     NilClass
                    ],
      "skills" => [:optional,
                   [[
                      {
                        "name" => String,
                        "level" => OPTIONAL_STRING,
                        "summary" => OPTIONAL_STRING,
                      }
                    ]],
                   NilClass
                  ],
      "driving" => [:optional,
                    [[ { "license" => String, } ]],
                    NilClass
                   ],
      "languages" => [:optional,
                      {
                        "mother_tongues" => [[
                                               {
                                                 "code" => OPTIONAL_STRING,
                                                 "language" => String,
                                               }
                                             ]],
                        "foreign" => [:optional,
                                      [[
                                         {
                                           "code" => OPTIONAL_STRING,
                                           "language" => String,
                                           "level" => OPTIONAL_STRING,
                                           "listening" => OPTIONAL_STRING,
                                           "reading" => OPTIONAL_STRING,
                                           "spoken_interaction" => OPTIONAL_STRING,
                                           "spoken_production" => OPTIONAL_STRING,
                                           "writing" =>  OPTIONAL_STRING
                                         }
                                       ]],
                                      NilClass
                                     ]
                      },
                      NilClass
                     ],
      "interests" => [:optional,
                      [[
                         {
                           "name" => String,
                           "level" => OPTIONAL_STRING,
                           "summary" => OPTIONAL_STRING,
                         }
                       ]],
                      NilClass
                     ],
      "references" => [:optional,
                       [[
                          {
                            "name" => String,
                            "reference" => String,
                            "contacts" => [[ {"label" => String, "value" => String} ]]
                          }
                        ]],
                       NilClass
                      ]
    }
  end
end
