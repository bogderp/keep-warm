# frozen_string_literal: false

require_relative 'gem_parser'
require_relative 'markdown_generator'
require 'clipboard'

module KeepWarm
  # Class responsible for generating markdown output from gem versions.
  class Processor
    attr_reader :markdown

    def initialize(filename)
      @filename = filename
      results = GemParser.parse_gem_versions(@filename)
      @categorized_gems = GemParser.categorize_and_sort_gems(results)
      @markdown = generate_markdown
    end

    def copy_markdown_to_clipboard
      Clipboard.copy(markdown)
      puts "\e[32mMarkdown copied to clipboard.\e[0m"
    end

    private

    def generate_markdown
      MarkdownGenerator.generate_output(@categorized_gems)
    end
  end
end
