# frozen_string_literal: false

module KeepWarm
  module Generator
    # Module responsible for generating markdown output from categorized gems.
    module Markdown
      class << self
        def generate_output(categorized_gems)
          categorized_gems.each_with_object('') do |(change_type, gem_list), markdown_output|
            section_title = change_type == 'New' ? 'New Gems' : "#{change_type} Changes"
            markdown_output << "### #{section_title}\n\n"
            markdown_output << "| Gem Name | Previous Version | New Version | Platform |\n"
            markdown_output << "| --- | --- | --- | --- |\n"
            gem_list.each do |gem|
              markdown_output << format_gem_entry(gem)
            end
            markdown_output << "\n"
          end
        end

        private

        def format_gem_entry(gem)
          gem_name = gem[:gem_name]
          previous_version = gem[:previous_version]
          new_version = gem[:new_version]
          platform = gem[:platform]

          "| #{gem_name} | #{previous_version} | #{new_version} | #{platform} |\n"
        end
      end
    end
  end
end
