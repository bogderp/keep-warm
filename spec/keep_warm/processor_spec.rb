# frozen_string_literal: true

require 'spec_helper'
require 'keep_warm'

RSpec.describe KeepWarm::Processor do
  let(:filename) { 'spec/fixtures/example_file.txt' }
  let(:keep_warm) { described_class.new(filename) }
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

  describe '#markdown' do
    let(:markdown_output) { keep_warm.markdown }
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

        ### N/A Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | strscan |  | 3.1.0 |  |

      MARKDOWN
    end

    it 'generates the correct markdown output' do
      expect(markdown_output).to eq(expected_output)
    end

    it 'categorizes major changes correctly' do
      expect(markdown_output).to include(<<~MARKDOWN)
        ### Major Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | highline | 1.7.10 | 2.0.3 |  |

      MARKDOWN
    end

    it 'categorizes minor changes correctly' do
      expect(markdown_output).to include(<<~MARKDOWN)
        ### Minor Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |\n| execjs | 2.7.0 | 2.9.1 |  |
        | grpc | 1.62.0 | 1.64.0 | arm64-darwin |

      MARKDOWN
    end

    it 'categorizes patch changes correctly' do
      expect(markdown_output).to include(<<~MARKDOWN)
        ### Patch Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |\n| ast | 2.4.0 | 2.4.2 |  |
        | bigdecimal | 3.1.7 | 3.1.8 |  |\n| minitest | 5.23.0 | 5.23.1 |  |

      MARKDOWN
    end

    it 'categorizes N/A changes correctly' do
      expect(markdown_output).to include(<<~MARKDOWN)
        ### N/A Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | strscan |  | 3.1.0 |  |

      MARKDOWN
    end
  end
end
