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

You should get some output that looks like this when added to a markdown file:  

<img width="300" alt="image" src="https://github.com/bogderp/keep-warm/assets/9342394/6b9cfe9e-cd61-4697-9fb9-53c17dc3754d">

