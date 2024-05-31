# frozen_string_literal: false

require 'clipboard'
require_relative 'gem_parser'
require_relative 'generator/markdown'
require_relative 'generator/csv'
require_relative 'generator/json'

module KeepWarm
  # Class responsible for generating detailed output from gem versions.
  class Processor
    attr_reader :output

    def initialize(filename)
      @configuration = KeepWarm.configuration ||= KeepWarm::Configuration.new
      @filename = filename
      results = GemParser.parse_gem_versions(@filename)
      @categorized_gems = GemParser.categorize_and_sort_gems(results)
      @output = generate_output
    end

    def run
      case configuration.output
      when :standard_output
        puts output
      when :clipboard
        copy_output_to_clipboard
      when :standard_output_clipboard
        output_to_standard_output_and_clipboard
      when :file
        write_to_file
      end
    end

    private

    attr_reader :configuration

    def generate_output
      configuration.generator.generate_output(@categorized_gems)
    end

    def copy_output_to_clipboard
      Clipboard.copy(output)
      puts "\e[32m#{configuration.format_name} copied to clipboard.\e[0m"
    end

    def output_to_standard_output_and_clipboard
      copy_output_to_clipboard
      sleep 1

      puts
      puts output
    end

    def write_to_file
      file_extension = configuration.file_extension
      output_dir = configuration.output_dir.chomp('/')
      location = "#{output_dir}/keep-warm-output.#{file_extension}"

      # TODO: Catch failed write.
      puts "Writing to #{location}"
      File.write(location, output)
      puts 'Done'
    end
  end
end
