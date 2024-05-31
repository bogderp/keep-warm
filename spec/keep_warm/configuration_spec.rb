# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/keep_warm/configuration'

RSpec.describe KeepWarm::Configuration do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets the default format to :markdown' do
      expect(config.format).to eq(:markdown)
    end

    it 'sets the default output to :standard_output_clipboard' do
      expect(config.output).to eq(:standard_output_clipboard)
    end

    it 'sets the default output_dir to "."' do
      expect(config.output_dir).to eq('.')
    end
  end

  describe '#file_extension' do
    it 'returns the correct file extension for :markdown' do
      config.format = :markdown
      expect(config.file_extension).to eq('md')
    end

    it 'returns the correct file extension for :csv' do
      config.format = :csv
      expect(config.file_extension).to eq('csv')
    end

    # it 'returns the correct file extension for :json' do
    #   config.format = :json
    #   expect(config.file_extension).to eq('json')
    # end

    # it 'returns the correct file extension for :yaml' do
    #   config.format = :yaml
    #   expect(config.file_extension).to eq('yml')
    # end

    # it 'returns the correct file extension for :html' do
    #   config.format = :html
    #   expect(config.file_extension).to eq('html')
    # end
  end

  describe '#format_name' do
    it 'returns the correct format name for :markdown' do
      config.format = :markdown
      expect(config.format_name).to eq('Markdown')
    end

    it 'returns the correct format name for :csv' do
      config.format = :csv
      expect(config.format_name).to eq('CSV')
    end

    # it 'returns the correct format name for :json' do
    #   config.format = :json
    #   expect(config.format_name).to eq('JSON')
    # end

    # it 'returns the correct format name for :yaml' do
    #   config.format = :yaml
    #   expect(config.format_name).to eq('YAML')
    # end

    # it 'returns the correct format name for :html' do
    #   config.format = :html
    #   expect(config.format_name).to eq('HTML')
    # end
  end
end
