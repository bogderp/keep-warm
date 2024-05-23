# frozen_string_literal: true

require 'rspec'
require_relative '../lib/keep_warm'
require 'fileutils'

RSpec.describe KeepWarm do
  let(:filename) { 'spec/fixtures/example_file.txt' }
  let(:keep_warm) { described_class.new(filename) }
  let(:expected_parsed_results) do
    [
      { gem_name: 'minitest', new_version: '5.23.1', previous_version: '5.23.0' },
      { gem_name: 'ast', new_version: '2.4.2', previous_version: '2.4.0' },
      { gem_name: 'execjs', new_version: '2.9.1', previous_version: '2.7.0' },
      { gem_name: 'bigdecimal', new_version: '3.1.8', previous_version: '3.1.7' },
      { gem_name: 'uglifier', new_version: '4.2.0', previous_version: '3.0.0' },
      { gem_name: 'strscan', new_version: '3.1.0', previous_version: nil },
      { gem_name: 'childprocess', new_version: '5.0.0', previous_version: nil }
    ]
  end

  before do
    FileUtils.mkdir_p('spec/fixtures')
    File.write(filename, <<~DATA)
      Fetching minitest 5.23.1 (was 5.23.0)
      Fetching ast 2.4.2 (was 2.4.0)
      Fetching execjs 2.9.1 (was 2.7.0)
      Fetching bigdecimal 3.1.8 (was 3.1.7)
      Fetching uglifier 4.2.0 (was 3.0.0)
      Fetching strscan 3.1.0
      Fetching childprocess 5.0.0
    DATA
  end

  after do
    FileUtils.rm_f(filename)
  end

  describe '#parse_gem_versions' do
    it 'parses gem versions correctly' do
      parsed_results = keep_warm.parse_gem_versions
      expect(parsed_results).to match_array(expected_parsed_results)
    end
  end

  describe '#version_change_type' do
    it 'identifies major changes' do
      expect(keep_warm.version_change_type('1.0.0', '2.0.0')).to eq('Major')
    end

    it 'identifies minor changes' do
      expect(keep_warm.version_change_type('1.0.0', '1.1.0')).to eq('Minor')
    end

    it 'identifies patch changes' do
      expect(keep_warm.version_change_type('1.0.0', '1.0.1')).to eq('Patch')
    end

    it 'identifies N/A changes' do
      expect(keep_warm.version_change_type(nil, '1.0.0')).to eq('N/A')
    end

    it 'identifies unknown changes' do
      expect(keep_warm.version_change_type('1.0.0', '1.0.0')).to eq('unknown')
    end
  end

  describe '#categorize_and_sort_gems' do
    it 'categorizes major changes correctly' do
      categorized_gems = keep_warm.categorize_and_sort_gems(expected_parsed_results)
      expect(categorized_gems['Major']).to eq([expected_parsed_results[4]])
    end

    it 'categorizes minor changes correctly' do
      categorized_gems = keep_warm.categorize_and_sort_gems(expected_parsed_results)
      expect(categorized_gems['Minor']).to contain_exactly(expected_parsed_results[2])
    end

    it 'categorizes patch changes correctly' do
      categorized_gems = keep_warm.categorize_and_sort_gems(expected_parsed_results)
      expect(categorized_gems['Patch']).to contain_exactly(expected_parsed_results[0], expected_parsed_results[1],
                                                           expected_parsed_results[3])
    end

    it 'categorizes N/A changes correctly' do
      categorized_gems = keep_warm.categorize_and_sort_gems(expected_parsed_results)
      expect(categorized_gems['N/A']).to contain_exactly(expected_parsed_results[5], expected_parsed_results[6])
    end
  end

  describe '#generate_markdown_output' do
    let(:categorized_gems) { keep_warm.categorize_and_sort_gems(expected_parsed_results) }
    let(:markdown_output) { keep_warm.generate_markdown_output(categorized_gems) }

    context 'when there are major changes' do
      it 'includes correct markdown' do
        expected_output = <<~MARKDOWN
          ### Major Changes

          - uglifier: `3.0.0` to: `4.2.0`

        MARKDOWN
        expect(markdown_output).to include(expected_output)
      end
    end

    context 'when there are minor changes' do
      it 'includes correct markdown' do
        expected_output = <<~MARKDOWN
          ### Minor Changes

          - execjs: `2.7.0` to: `2.9.1`

        MARKDOWN
        expect(markdown_output).to include(expected_output)
      end
    end

    context 'when there are patch changes' do
      it 'includes correct markdown for ast' do
        expected_output = "- ast: `2.4.0` to: `2.4.2`\n"
        expect(markdown_output).to include(expected_output)
      end

      it 'includes correct markdown for bigdecimal' do
        expected_output = "- bigdecimal: `3.1.7` to: `3.1.8`\n"
        expect(markdown_output).to include(expected_output)
      end

      it 'includes correct markdown for minitest' do
        expected_output = "- minitest: `5.23.0` to: `5.23.1`\n"
        expect(markdown_output).to include(expected_output)
      end
    end

    context 'when there are new additions' do
      it 'includes correct markdown for childprocess' do
        expected_output = "- childprocess: `5.0.0`\n"
        expect(markdown_output).to include(expected_output)
      end

      it 'includes correct markdown for strscan' do
        expected_output = "- strscan: `3.1.0`\n"
        expect(markdown_output).to include(expected_output)
      end
    end
  end
end
