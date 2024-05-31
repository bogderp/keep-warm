# frozen_string_literal: true

require 'json'

module KeepWarm
  module Generator
    # Module responsible for generating JSON output from categorized gems.
    module JSON
      class << self
        def generate_output(categorized_gems)
          categorized_gems.transform_keys(&:downcase).to_json
        end
      end
    end
  end
end
