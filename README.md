# KeepWarm

A simple Ruby script to parse gem versions and generate a markdown report.

## Installation

```sh
bundle install
```

## Running the script

Before running the script, update your bundle and save the output to a file using the following command:

```sh
bundle update > output.txt
```

Afterwards, run the script using the output file as an argument:

```sh
./bin/keep_warm output.txt
```

Ensure that you are in the correct directory where the keep_warm.rb file is located before running the commands.

## IRB Console

You can also run the script in an IRB console after installing the gem by initializing the class and passing the output file as an argument:

```ruby
  require 'keep_warm'

  keep_warm = KeepWarm::Processor.new('output.txt')
```

## Configuration
KeepWarm can be configured using a block. Currently, only the markdown format is supported. The default output is both clipboard and standard output (:standard_output_clipboard), but it can also be set to file (:file) or clipboard (:clipboard). By default, output_dir is ./.

### Configuration Options
| Option | Description | Default | Possible Values |
| -------- | ---------------- | ----------- | -------- |
| format | Output format of the report. | :markdown | :markdown |
| output | Output destination for the report. | :standard_output_clipboard | :file, :clipboard, :standard_output_clipboard |
| output_dir | Directory where the report file will be saved (if output is set to :file). | './' | Any valid directory path |


### Example Configuration

#### Setting Format and Output to File

```ruby
KeepWarm.configure do |config|
  config.format = :markdown
  config.output = :file
  config.output_dir = 'bin/'
end
```

#### Default Configuration
```ruby
KeepWarm.configure do |config|
  config.format = :markdown
  config.output = :standard_output_clipboard
end

KeepWarm::Processor.new('output.txt').run
```

### Generating Markdown

To generate markdown, configure the format and run the processor:

```ruby
KeepWarm.configure do |config|
  config.format = :markdown
end

keep_warm = KeepWarm::Processor.new('output.txt')
keep_warm.run
```

### Copying to Clipboard

To copy the markdown to your clipboard:

```ruby
  KeepWarm.configure do |config|
    config.output = :clipboard
  end

  keep_warm = KeepWarm::Processor.new('output.txt')
  keep_warm.run
```

You should get output that looks like this when previewing the output in a markdown file:

<img width="300" alt="image" src="https://github.com/bogderp/keep-warm/assets/9342394/6b9cfe9e-cd61-4697-9fb9-53c17dc3754d">

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bogderp/keep_warm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
