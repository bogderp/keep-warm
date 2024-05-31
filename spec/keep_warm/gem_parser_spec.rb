# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/keep_warm/gem_parser'

RSpec.describe KeepWarm::GemParser do
  let(:filename) { 'spec/fixtures/example_file.txt' }
  let(:file_content) do
    <<~DATA
      Using minitest 5.23.1 (was 5.23.0)
      Fetching ast 2.4.2 (was 2.4.0)
      Using execjs 2.9.1 (was 2.7.0)
      Using grpc 1.64.0 (arm64-darwin) (was 1.62.0)
      Fetching strscan 3.1.0
    DATA
  end
  let(:parsed_results) do
    [
      { gem_name: 'minitest', new_version: '5.23.1', previous_version: '5.23.0', platform: nil },
      { gem_name: 'ast', new_version: '2.4.2', previous_version: '2.4.0', platform: nil },
      { gem_name: 'execjs', new_version: '2.9.1', previous_version: '2.7.0', platform: nil },
      { gem_name: 'grpc', new_version: '1.64.0', previous_version: '1.62.0', platform: 'arm64-darwin' },
      { gem_name: 'strscan', new_version: '3.1.0', previous_version: nil, platform: nil }
    ]
  end

  before do
    FileUtils.mkdir_p('spec/fixtures')
    File.write(filename, file_content)
  end

  after do
    FileUtils.rm_f(filename)
  end

  describe '.parse_gem_versions' do
    it 'parses gem versions correctly' do
      expect(described_class.parse_gem_versions(filename)).to eq(parsed_results)
    end
  end

  describe '.categorize_and_sort_gems' do
    let(:categorized_gems) do
      {
        'Major' => [],
        'Minor' => [
          { gem_name: 'execjs', new_version: '2.9.1', previous_version: '2.7.0', platform: nil },
          { gem_name: 'grpc', new_version: '1.64.0', previous_version: '1.62.0', platform: 'arm64-darwin' }
        ],
        'Patch' => [
          { gem_name: 'ast', new_version: '2.4.2', previous_version: '2.4.0', platform: nil },
          { gem_name: 'minitest', new_version: '5.23.1', previous_version: '5.23.0', platform: nil }
        ],
        'New' => [
          { gem_name: 'strscan', new_version: '3.1.0', previous_version: nil, platform: nil }
        ]
      }
    end

    it 'categorizes and sorts gems correctly' do
      parsed_gems = described_class.parse_gem_versions(filename)
      expect(described_class.categorize_and_sort_gems(parsed_gems)).to eq(categorized_gems)
    end
  end

  describe '.extract_gem_info' do
    it 'extracts gem info correctly' do
      line = 'Using minitest 5.23.1 (was 5.23.0)'
      expected_info = { gem_name: 'minitest', new_version: '5.23.1', previous_version: '5.23.0', platform: nil }
      expect(described_class.send(:extract_gem_info, line)).to eq(expected_info)
    end

    it 'returns nil for unsupported line formats' do
      line = 'Some unsupported line format'
      expect(described_class.send(:extract_gem_info, line)).to be_nil
    end
  end

  describe '.version_change_type' do
    it 'returns Major for major version changes' do
      expect(described_class.send(:version_change_type, '1.0.0', '2.0.0')).to eq('Major')
    end

    it 'returns Minor for minor version changes' do
      expect(described_class.send(:version_change_type, '1.0.0', '1.1.0')).to eq('Minor')
    end

    it 'returns Patch for patch version changes' do
      expect(described_class.send(:version_change_type, '1.0.0', '1.0.1')).to eq('Patch')
    end

    it 'returns New for nil previous versions' do
      expect(described_class.send(:version_change_type, nil, '1.0.0')).to eq('New')
    end

    it 'returns unknown for non-incremental changes' do
      expect(described_class.send(:version_change_type, '1.0.0', '1.0.0')).to eq('unknown')
    end
  end
end
