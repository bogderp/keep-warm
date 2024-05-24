# KeepWarm

A simple Ruby script to parse gem versions and generate a markdown report.

## Installation

```sh
bundle install
```

## Running the script

Before running the script, you need to update your bundle and save the output to a file. You can do this using the following command:

```sh
bundle update > output.txt
```

Afterwards, you can run the script using the output file as an argument:

```sh
./bin/keep_warm output.txt
```

Please ensure that you are in the correct directory where the `keep_warm.rb` file is located before running the commands.

## IRB Console

You can also run the script in an IRB console after installing the gem. You can do this by initializing the class and passing the output file as an argument:

```ruby
  require 'keep_warm'

  keep_warm = KeepWarm::Processor.new('output.txt')
```

### Generating Markdown

You can generate markdown by calling `markdown` on the `KeepWarm` object:

```ruby
  keep_warm.markdown
```

### Copying to Clipboard

You can copy the markdown to your clipboard by calling `copy_markdown_to_clipboard` on the `KeepWarm` object:

```ruby
  keep_warm.copy_markdown_to_clipboard
```

You should get some output that looks like this when previewing the output in a markdown file:

<img width="300" alt="image" src="https://github.com/bogderp/keep-warm/assets/9342394/6b9cfe9e-cd61-4697-9fb9-53c17dc3754d">

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/keep_warm.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
