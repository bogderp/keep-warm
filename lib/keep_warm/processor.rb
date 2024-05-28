# frozen_string_literal: false

require_relative 'gem_parser'
require_relative 'markdown_generator'
require 'clipboard'

module KeepWarm
  # Class responsible for generating markdown output from gem versions.
  class Processor
    attr_reader :markdown

    def initialize(filename)
      KeepWarm.configuration ||= KeepWarm::Configuration.new
      @filename = filename
      results = GemParser.parse_gem_versions(@filename)
      @categorized_gems = GemParser.categorize_and_sort_gems(results)
      @markdown = generate_markdown
    end

    def run
      case KeepWarm.configuration.output
      when :standard_output
        puts markdown
      when :clipboard
        copy_markdown_to_clipboard
      when :standard_output_clipboard
        output_to_standard_output_and_clipboard
      when :file
        write_to_file
      end
    end

    private

    def generate_markdown
      MarkdownGenerator.generate_output(@categorized_gems)
    end

    def copy_markdown_to_clipboard
      Clipboard.copy(markdown)
      puts "\e[32mMarkdown copied to clipboard.\e[0m"
    end

    def output_to_standard_output_and_clipboard
      copy_markdown_to_clipboard
      sleep 1

      puts
      puts markdown
    end

    def write_to_file
      file_extension = KeepWarm.configuration.file_extension
      output_dir = KeepWarm.configuration.output_dir.chomp('/')
      location = "#{output_dir}/keep-warm-output.#{file_extension}"

      # TODO: Catch failed write.
      puts "Writing to #{location}"
      File.write(location, markdown)
      puts 'Done'
    end
  end
end
