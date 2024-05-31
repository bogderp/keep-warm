# frozen_string_literal: true

require 'csv'

module KeepWarm
  module Generator
    # Module responsible for generating markdown output from categorized gems.
    module CSV
      class << self
        def generate_output(categorized_gems)
          ::CSV.generate(headers: true) do |csv|
            csv << ['Change Type', 'Gem Name', 'Previous Version', 'New Version', 'Platform']

            categorized_gems.each do |change_type, gem_list|
              gem_list.each do |gem|
                csv << [change_type, gem[:gem_name], gem[:previous_version], gem[:new_version], gem[:platform]]
              end
            end
          end
        end
      end
    end
  end
end
