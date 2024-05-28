# frozen_string_literal: true

module KeepWarm
  # Class responsible for TODO
  class Configuration
    attr_accessor :format, :output, :output_dir

    FORMAT_FILE_EXT_MAPPINGS = {
      markdown: 'md'
      # csv: 'csv',
      # json: 'json',
      # yaml: 'yml',
      # yml: 'yml',
      # html: 'html'
    }.freeze

    def initialize
      @format = :markdown
      @output = :standard_output_clipboard
      @output_dir = '.'
    end

    def file_extension
      @file_extension ||= FORMAT_FILE_EXT_MAPPINGS[@format]
    end
  end
end
