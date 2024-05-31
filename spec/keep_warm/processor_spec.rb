# frozen_string_literal: true

require 'spec_helper'
require 'keep_warm'
require 'fileutils'
require 'clipboard'

RSpec.describe KeepWarm::Processor do
  let(:filename) { 'spec/fixtures/example_file.txt' }
  let(:processor) { described_class.new(filename) }
  let(:file_content) do
    <<~DATA
      Fetching https://github.com/honzasterba/google-drive-ruby.git
      Fetching https://github.com/98-f355-f1/bootstrap-editable-rails
      Fetching gem metadata from https://enterprise.contribsys.com/..
      Fetching gem metadata from https://rubygems.org/.......
      Resolving dependencies...
      Using minitest 5.23.1 (was 5.23.0)
      Using ast 2.4.2 (was 2.4.0)
      Using execjs 2.9.1 (was 2.7.0)
      Using bigdecimal 3.1.8 (was 3.1.7)
      Using grpc 1.64.0 (arm64-darwin) (was 1.62.0)
      Fetching strscan 3.1.0
      Fetching highline 2.0.3 (was 1.7.10)
    DATA
  end

  before do
    FileUtils.mkdir_p('spec/fixtures')
    File.write(filename, file_content)
  end

  after do
    FileUtils.rm_f(filename)
  end

  describe '#output' do
    context 'when format is set to :markdown' do
      before do
        KeepWarm.configure do |config|
          config.format = :markdown
        end
      end

      let(:markdown_output) { processor.output }
      let(:expected_output) do
        <<~MARKDOWN
          ### Major Changes

          | Gem Name | Previous Version | New Version | Platform |
          | --- | --- | --- | --- |
          | highline | 1.7.10 | 2.0.3 |  |

          ### Minor Changes

          | Gem Name | Previous Version | New Version | Platform |
          | --- | --- | --- | --- |
          | execjs | 2.7.0 | 2.9.1 |  |
          | grpc | 1.62.0 | 1.64.0 | arm64-darwin |

          ### Patch Changes

          | Gem Name | Previous Version | New Version | Platform |
          | --- | --- | --- | --- |
          | ast | 2.4.0 | 2.4.2 |  |
          | bigdecimal | 3.1.7 | 3.1.8 |  |
          | minitest | 5.23.0 | 5.23.1 |  |

          ### New Gems

          | Gem Name | Previous Version | New Version | Platform |
          | --- | --- | --- | --- |
          | strscan |  | 3.1.0 |  |

        MARKDOWN
      end

      it 'generates the correct markdown output' do
        expect(markdown_output).to eq(expected_output)
      end
    end

    context 'when format is set to :csv' do
      before do
        KeepWarm.configure do |config|
          config.format = :csv
        end
      end

      let(:csv_output) { processor.output }
      let(:expected_output) do
        CSV.generate(headers: true) do |csv|
          csv << ['Change Type', 'Gem Name', 'Previous Version', 'New Version', 'Platform']
          csv << ['Major', 'highline', '1.7.10', '2.0.3', nil]
          csv << ['Minor', 'execjs', '2.7.0', '2.9.1', nil]
          csv << ['Minor', 'grpc', '1.62.0', '1.64.0', 'arm64-darwin']
          csv << ['Patch', 'ast', '2.4.0', '2.4.2', nil]
          csv << ['Patch', 'bigdecimal', '3.1.7', '3.1.8', nil]
          csv << ['Patch', 'minitest', '5.23.0', '5.23.1', nil]
          csv << ['New', 'strscan', nil, '3.1.0', nil]
        end
      end

      it 'generates the correct CSV output' do
        expect(csv_output).to eq(expected_output)
      end
    end

    context 'when format is set to :json' do
      before do
        KeepWarm.configure do |config|
          config.format = :json
        end
      end

      let(:json_output) { processor.output }
      let(:expected_output) do
        {
          'major' => [
            { gem_name: 'highline', new_version: '2.0.3', platform: nil, previous_version: '1.7.10' }
          ],
          'minor' => [
            { gem_name: 'execjs', new_version: '2.9.1', platform: nil, previous_version: '2.7.0' },
            { gem_name: 'grpc', new_version: '1.64.0', platform: 'arm64-darwin', previous_version: '1.62.0' }
          ],
          'patch' => [
            { gem_name: 'ast', new_version: '2.4.2', platform: nil, previous_version: '2.4.0' },
            { gem_name: 'bigdecimal', new_version: '3.1.8', platform: nil, previous_version: '3.1.7' },
            { gem_name: 'minitest', new_version: '5.23.1', platform: nil, previous_version: '5.23.0' }
          ],
          'new' => [
            { gem_name: 'strscan', new_version: '3.1.0', platform: nil, previous_version: nil }
          ]
        }.to_json
      end

      it 'generates the correct JSON output' do
        expect(json_output).to eq(expected_output)
      end
    end
  end

  describe '#run' do
    context 'when output is set to :standard_output' do
      before do
        KeepWarm.configure do |config|
          config.output = :standard_output
        end
      end

      it 'outputs to standard output' do
        expect { processor.run }.to output(processor.output).to_stdout
      end
    end

    context 'when output is set to :clipboard' do
      before do
        KeepWarm.configure do |config|
          config.output = :clipboard
        end
        allow(Clipboard).to receive(:copy)
      end

      it 'copies the markdown to the clipboard' do
        processor.run
        expect(Clipboard).to have_received(:copy).with(processor.output)
      end

      it 'outputs a confirmation message to standard output' do
        expect do
          processor.run
        end.to output("\e[32m#{KeepWarm.configuration.format_name} copied to clipboard.\e[0m\n").to_stdout
      end
    end

    context 'when output is set to :standard_output_clipboard' do
      before do
        KeepWarm.configure do |config|
          config.output = :standard_output_clipboard
        end
        allow(Clipboard).to receive(:copy)
      end

      it 'copies the markdown to the clipboard' do
        processor.run
        expect(Clipboard).to have_received(:copy).with(processor.output)
      end

      it 'outputs to standard output and clipboard' do
        format = KeepWarm.configuration.format_name
        expect do
          processor.run
        end.to output("\e[32m#{format} copied to clipboard.\e[0m\n\n#{processor.output}").to_stdout
      end
    end

    context 'when output is set to :file' do
      it_behaves_like 'file output', :markdown, 'md', <<~MARKDOWN
        ### Major Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | highline | 1.7.10 | 2.0.3 |  |

        ### Minor Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | execjs | 2.7.0 | 2.9.1 |  |
        | grpc | 1.62.0 | 1.64.0 | arm64-darwin |

        ### Patch Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | ast | 2.4.0 | 2.4.2 |  |
        | bigdecimal | 3.1.7 | 3.1.8 |  |
        | minitest | 5.23.0 | 5.23.1 |  |

        ### New Gems

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | strscan |  | 3.1.0 |  |

      MARKDOWN

      it_behaves_like 'file output', :csv, 'csv', (CSV.generate(headers: true) do |csv|
        csv << ['Change Type', 'Gem Name', 'Previous Version', 'New Version', 'Platform']
        csv << ['Major', 'highline', '1.7.10', '2.0.3', nil]
        csv << ['Minor', 'execjs', '2.7.0', '2.9.1', nil]
        csv << ['Minor', 'grpc', '1.62.0', '1.64.0', 'arm64-darwin']
        csv << ['Patch', 'ast', '2.4.0', '2.4.2', nil]
        csv << ['Patch', 'bigdecimal', '3.1.7', '3.1.8', nil]
        csv << ['Patch', 'minitest', '5.23.0', '5.23.1', nil]
        csv << ['New', 'strscan', nil, '3.1.0', nil]
      end)

      it_behaves_like 'file output', :json, 'json', {
        'major' => [
          { gem_name: 'highline', new_version: '2.0.3', platform: nil, previous_version: '1.7.10' }
        ],
        'minor' => [
          { gem_name: 'execjs', new_version: '2.9.1', platform: nil, previous_version: '2.7.0' },
          { gem_name: 'grpc', new_version: '1.64.0', platform: 'arm64-darwin', previous_version: '1.62.0' }
        ],
        'patch' => [
          { gem_name: 'ast', new_version: '2.4.2', platform: nil, previous_version: '2.4.0' },
          { gem_name: 'bigdecimal', new_version: '3.1.8', platform: nil, previous_version: '3.1.7' },
          { gem_name: 'minitest', new_version: '5.23.1', platform: nil, previous_version: '5.23.0' }
        ],
        'new' => [
          { gem_name: 'strscan', new_version: '3.1.0', platform: nil, previous_version: nil }
        ]
      }.to_json
    end
  end
end
