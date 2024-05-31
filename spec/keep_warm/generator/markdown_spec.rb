# frozen_string_literal: true

require 'rspec'
require_relative '../../../lib/keep_warm/generator/markdown'

RSpec.describe KeepWarm::Generator::Markdown do
  let(:categorized_gems) do
    {
      'Major' => [
        { gem_name: 'major_gem', new_version: '2.0.0', previous_version: '1.0.0', platform: nil }
      ],
      'Minor' => [
        { gem_name: 'minor_gem', new_version: '1.1.0', previous_version: '1.0.0', platform: nil }
      ],
      'Patch' => [
        { gem_name: 'patch_gem', new_version: '1.0.1', previous_version: '1.0.0', platform: nil }
      ],
      'New' => [
        { gem_name: 'na_gem', new_version: '1.0.0', previous_version: nil, platform: nil }
      ]
    }
  end

  describe '.generate_output' do
    let(:expected_output) do
      <<~MARKDOWN
        ### Major Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | major_gem | 1.0.0 | 2.0.0 |  |

        ### Minor Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | minor_gem | 1.0.0 | 1.1.0 |  |

        ### Patch Changes

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | patch_gem | 1.0.0 | 1.0.1 |  |

        ### New Gems

        | Gem Name | Previous Version | New Version | Platform |
        | --- | --- | --- | --- |
        | na_gem |  | 1.0.0 |  |

      MARKDOWN
    end

    it 'generates the correct markdown output' do
      output = described_class.generate_output(categorized_gems)
      expect(output).to eq(expected_output)
    end
  end

  describe '.format_gem_entry' do
    it 'formats the gem entry correctly' do
      gem = { gem_name: 'test_gem', new_version: '1.0.0', previous_version: '0.9.0', platform: nil }
      expected_entry = "| test_gem | 0.9.0 | 1.0.0 |  |\n"
      expect(described_class.send(:format_gem_entry, gem)).to eq(expected_entry)
    end

    it 'formats the gem entry correctly with platform' do
      gem = { gem_name: 'test_gem', new_version: '1.0.0', previous_version: '0.9.0', platform: 'ruby' }
      expected_entry = "| test_gem | 0.9.0 | 1.0.0 | ruby |\n"
      expect(described_class.send(:format_gem_entry, gem)).to eq(expected_entry)
    end

    it 'formats the gem entry correctly with nil previous_version' do
      gem = { gem_name: 'test_gem', new_version: '1.0.0', previous_version: nil, platform: nil }
      expected_entry = "| test_gem |  | 1.0.0 |  |\n"
      expect(described_class.send(:format_gem_entry, gem)).to eq(expected_entry)
    end
  end
end
