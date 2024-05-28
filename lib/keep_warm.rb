#!/usr/bin/env ruby
# frozen_string_literal: false

require_relative 'keep_warm/version'
require_relative 'keep_warm/configuration'
require_relative 'keep_warm/processor'

# Main module for the KeepWarm gem.
module KeepWarm
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
