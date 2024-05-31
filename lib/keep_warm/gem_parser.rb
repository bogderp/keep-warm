# frozen_string_literal: false

module KeepWarm
  # Module responsible for parsing gem versions and categorizing them.
  module GemParser
    class << self
      def parse_gem_versions(filename)
        lines = File.readlines(filename)
        lines.each_with_object([]) do |line, parsed_results|
          gem_info = extract_gem_info(line)
          parsed_results << gem_info if gem_info
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

      private

      def extract_gem_info(line)
        match_data = match_gem_info(line)
        return unless match_data

        {
          gem_name: match_data[:gem_name],
          new_version: match_data[:new_version],
          platform: match_data[:platform],
          previous_version: match_data[:previous_version]
        }
      end

      def match_gem_info(line)
        [
          [/Using (\w+) (\d+\.\d+\.\d+)( \(([\w.-]+)\))? \(was (\d+\.\d+\.\d+)\)/, true],
          [/Fetching (\w+) (\d+\.\d+\.\d+)( \(([\w.-]+)\))? \(was (\d+\.\d+\.\d+)\)/, true],
          [/Using (\w+) (\d+\.\d+\.\d+)( \(([\w.-]+)\))?/, false],
          [/Fetching (\w+) (\d+\.\d+\.\d+)( \(([\w.-]+)\))?/, false]
        ].each do |pattern, with_previous|
          match_data = line.match(pattern)
          return parse_match_data(match_data, with_previous) if match_data
        end

        nil
      end

      def parse_match_data(match_data, with_previous_version)
        {
          gem_name: match_data[1],
          new_version: match_data[2],
          platform: match_data[4],
          previous_version: with_previous_version ? match_data[5] : nil
        }
      end

      def version_change_type(previous_version, new_version)
        return 'New' if previous_version.nil?

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

      def initialize_categories
        {
          'Major' => [],
          'Minor' => [],
          'Patch' => [],
          'New' => []
        }
      end

      def sort_gem_categories(categorized_gems)
        categorized_gems.each do |key, gem_list|
          categorized_gems[key] = gem_list.sort_by { |gem| gem[:gem_name] }
        end

        categorized_gems
      end
    end
  end
end
