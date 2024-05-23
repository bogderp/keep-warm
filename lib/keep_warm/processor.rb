# frozen_string_literal: false

require_relative 'gem_parser'
require_relative 'markdown_generator'

module KeepWarm
  # Class responsible for generating markdown output from gem versions.
  class Processor
    def initialize(filename)
      @filename = filename
    end

    def generate_markdown
      results = KeepWarm::GemParser.parse_gem_versions(@filename)
      categorized_gems = KeepWarm::GemParser.categorize_and_sort_gems(results)
      KeepWarm::MarkdownGenerator.generate_output(categorized_gems)
    end
  end
end
