# RESME - A Resume Generator

Keep your resume in YAML and output it in various formats, including
markdown, json, and the Europass XML format.

Interesting features:

- the rendering engine is based on ERB.  This simplifies the creation
  of new output formats (and extending/modifying the YML structure to
  one's needs).
- no gem/cli application I am aware of outputs in the Europass format


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resme'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install resme

## Usage

Start with:

    $ resme init

whih generates a YML template for your resume in the current
directory.  Comments in the YML file should help you fill the various
entries.  Notice that most entries are optional and you can remove
sectins hich are not relevant for your resume.

Once you have started filling you resume, you can then generate a
resume using the existing templates or by writing your own template
(see below).

To generate a resume in Markdown using the provided template:

   $ resme md [-o output_filename] file.yml ... 

To generate a resume in the Europass XML format using the provided template:

   $ resme europass [-o output_filename] file.yml ...

To generate a resume in the Json format (https://jsonresume.org/):

   $ resme json [-o output_filename] file.yaml ...

Remarks:

* you can specify more than one YML file in input.  This allows you to store
  data about your resume in different files, if you like to do so (e.g., work
  experiences could be in one file and talks in another).  The YML files are
  merged before processing them.
* the output filename is optional.  If you do not specify one, the resume is
  generated to `resume-YYYY.MM.DD.format`, where `YYYY-MM-DD` is today's date
  and `format` is the chosen output format

## Dates in the resume

Enter dates in the resume in one of the following formats:

* Any format accepted by Ruby for a full date (year, month, day)
* YYYY-MM-DD
* YYYY-MM
* YYYY

The third and the forth format allows you to enter "partial" dates
(e.g., when the month or the day have been forgotten or are
irrelevant).

## Creating your own templates

The resumes are generated from the YML matter using ERB templates,
similar to what Jekyll and Middleman do with data files.  (See,
e.g., [data files](https://middlemanapp.com/advanced/data-files/.)
You can define your own templates if you wish to do so.

All the data in the resume is made available in the `data` variable.
Thus, for instance, the following code snippets generates a list of
all the work experiences:

	<% data.work each do |exp| %>
	- <%= exp.who %>
	  From: <%=  exp.from %> till: <%= exp.till %>
	<% end %>

To specify your own ERB template use the option `-t`. Thus, for instance:

    $ resme render -t template.md.erb [-o output_filename] file.yaml ...

uses `template.md.erb` to generate the resume.

Some functions can be used in the templates to better control the output.

String manipulation functions:

* `clean string` removes any space at the beginning of `string`
* `reflow string, n` makes `string` into an array of strings of
  length lower or equal to `n` (useful if you are outputing a txt format,
  for instance.

Dates manipulation functions:

* `year string`, `month string`, `day string` return, respectively the
  year, month and day from strings in the format `YYYY-MM-DD`s
* `has_month input` returns true if `input` has a month, that is, it is
  a date or it is in the form `YYYY-MM`
* `has_day input` returns true if `input` has a day, that is, it is
  a date or it is in the form `YYYY-MM-DD`

You can find some templates in `lib/resme/templates`.  These might be
good starting points if you want to develop your own.

## Contributing your templates

If you develop an output template and want to make it available,
please let me know, so that I can include it in future releases of
this gem.

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/avillafiorita/resme.

## License

The gem is available as open source under the terms of
the [MIT License](http://opensource.org/licenses/MIT).

## Roadmap

In `doc/todo.org` ... guess what is my preferred editor!

## Bugs
 
There are slight differences in the information outputted in the
various formats.  For instance, gender and birthdate are used in the
Europass format, but not in the Markdown format.  This is in part due
to the different standards and in part due to personal choices (here
"personal choices" could be also read "bug").

Entries are not sorted by date before outputting them.  Make sure you
put them in the order you want them to appear in your resume.

Unkown number of unkown bugs.

## Release History

* **0.1** is th first release
