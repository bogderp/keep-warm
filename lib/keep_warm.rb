#!/usr/bin/env ruby
# frozen_string_literal: false

require_relative 'gem_parser'
require_relative 'markdown_generator'

# Class responsible for generating markdown output from gem versions.
class KeepWarm
  def initialize(filename)
    @filename = filename
  end

  def generate_markdown
    results = GemParser.parse_gem_versions(@filename)
    categorized_gems = GemParser.categorize_and_sort_gems(results)
    MarkdownGenerator.generate_output(categorized_gems)
  end
end
