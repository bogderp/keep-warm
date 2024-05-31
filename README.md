# KeepWarm

KeepWarm is a Ruby gem for parsing gem version changes and generating reports in various formats such as Markdown and CSV.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keep_warm'
```

And then execute:

```sh
bundle install
```
Or install it yourself as:

```sh
gem install keep_warm
```
## Usage

### Configuration
You can configure KeepWarm in your application initializer or script. Here's an example configuration:

```ruby
KeepWarm.configure do |config|
  config.format = :markdown   # Available formats: :markdown, :csv, :json
  config.output = :file       # Available outputs: :standard_output, :clipboard, :standard_output_clipboard, :file
  config.output_dir = './tmp' # Directory where the file will be written (if output is :file)
end
```

#### Formats
* `:markdown`: Generates a report in Markdown format.
* `:csv`: Generates a report in CSV format.
* `:json`: Generates a report in JSON format.
* Additional formats will added in the future, such as YAML and HTML.

#### Outputs
* :standard_output: Prints the report to the standard output.
* :clipboard: Copies the report to the clipboard.
* :standard_output_clipboard: Prints the report to the standard output and copies it to the clipboard.
* :file: Writes the report to a file in the specified output directory.

#### File Extensions
The file extension for the output file is determined by the format:

* `:markdown` -> `.md`
* `:csv` -> `.csv`
* `:json` -> `.json`
* Additional formats will have their corresponding extensions.

### Examples

#### Standalone Script
You can use KeepWarm as a standalone script. Here’s an example:

```sh
./bin/keep_warm path/to/your_file.txt
```

#### Using in IRB or Rails Console
You can also use KeepWarm in an IRB or Rails console:

```ruby
require 'keep_warm'

KeepWarm.configure do |config|
  config.format = :csv
  config.output = :file
  config.output_dir = './tmp/'
end

processor = KeepWarm::Processor.new('path/to/your_file.txt')
processor.run
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bogderp/keep_warm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
