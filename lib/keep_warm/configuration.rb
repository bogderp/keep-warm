# frozen_string_literal: true

module KeepWarm
  # Class responsible for storing and managing the configuration
  class Configuration
    attr_accessor :format, :output, :output_dir

    FORMAT_FILE_EXT_MAPPINGS = {
      markdown: 'md',
      csv: 'csv'
      # json: 'json',
      # yaml: 'yaml',
      # yml: 'yml',
      # html: 'html'
    }.freeze

    FORMAT_NAMES = {
      markdown: 'Markdown',
      csv: 'CSV'
      # json: 'JSON',
      # yaml: 'YAML',
      # yml: 'YAML',
      # html: 'HTML'
    }.freeze

    def initialize
      @format = :markdown
      @output = :standard_output_clipboard
      @output_dir = '.'
    end

    def file_extension
      FORMAT_FILE_EXT_MAPPINGS[@format]
    end

    def format_name
      FORMAT_NAMES[@format]
    end

    def generator
      case @format
      when :csv
        Generator::CSV
      else
        Generator::Markdown
      end
    end
  end
end
