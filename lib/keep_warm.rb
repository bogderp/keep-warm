#!/usr/bin/env ruby
# frozen_string_literal: false

require 'fileutils'

# Class responsible for parsing gem versions, categorizing them based on version changes,
# and generating markdown output.
class KeepWarm
  def initialize(filename)
    @filename = filename
  end

  def generate_markdown
    results = parse_gem_versions
    categorized_gems = categorize_and_sort_gems(results)
    generate_markdown_output(categorized_gems)
  end

  def parse_gem_versions
    lines = File.readlines(@filename)
    lines.each_with_object([]) do |line, parsed_results|
      gem_info = extract_gem_info(line)
      parsed_results << gem_info if gem_info
    end
  end

  def extract_gem_info(line)
    match = line.match(/Fetching (\w+) (\d+\.\d+\.\d+)( \(was (\d+\.\d+\.\d+)\))?/)
    return unless match

    {
      gem_name: match[1],
      new_version: match[2],
      previous_version: match[4]
    }
  end

  def version_change_type(previous_version, new_version)
    return 'N/A' if previous_version.nil?

    prev_parts = version_parts(previous_version)
    new_parts = version_parts(new_version)

    determine_change_type(prev_parts, new_parts)
  end

  def version_parts(version)
    version.split('.').map(&:to_i)
  end

  def determine_change_type(prev_parts, new_parts)
    if new_parts[0] > prev_parts[0]
      'Major'
    elsif new_parts[1] > prev_parts[1]
      'Minor'
    elsif new_parts[2] > prev_parts[2]
      'Patch'
    else
      'unknown'
    end
  end

  def categorize_and_sort_gems(gems)
    categorized_gems = initialize_categories

    gems.each do |gem|
      change_type = version_change_type(gem[:previous_version], gem[:new_version])
      categorized_gems[change_type] << gem
    end

    sort_gem_categories(categorized_gems)
  end

  def initialize_categories
    {
      'Major' => [],
      'Minor' => [],
      'Patch' => [],
      'N/A' => []
    }
  end

  def sort_gem_categories(categorized_gems)
    categorized_gems.each do |key, gem_list|
      categorized_gems[key] = gem_list.sort_by { |gem| gem[:gem_name] }
    end

    categorized_gems
  end

  def generate_markdown_output(categorized_gems)
    categorized_gems.each_with_object('') do |(change_type, gem_list), markdown_output|
      markdown_output << "### #{change_type} Changes\n\n"
      gem_list.each do |gem|
        markdown_output << format_gem_entry(change_type, gem)
      end
      markdown_output << "\n"
    end
  end

  def format_gem_entry(change_type, gem)
    if change_type == 'N/A'
      "- #{gem[:gem_name]}: `#{gem[:new_version]}`\n"
    else
      "- #{gem[:gem_name]}: `#{gem[:previous_version]}` to: `#{gem[:new_version]}`\n"
    end
  end
end
