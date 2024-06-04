# frozen_string_literal: true

require 'yaml'

module KeepWarm
  module Generator
    # Module responsible for generating YAML output from categorized gems.
    module YAML
      class << self
        def generate_output(categorized_gems)
          categorized_gems.transform_keys(&:downcase).to_yaml
        end
      end
    end
  end
end
