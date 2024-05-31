# frozen_string_literal: true

require 'rspec'
require 'json'
require_relative '../../../lib/keep_warm/generator/json'

RSpec.describe KeepWarm::Generator::JSON do
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
        { gem_name: 'new_gem', new_version: '1.0.0', previous_version: nil, platform: nil }
      ]
    }
  end

  describe '.generate_output' do
    let(:expected_output) do
      {
        'major' => [
          { gem_name: 'major_gem', new_version: '2.0.0', previous_version: '1.0.0', platform: nil }
        ],
        'minor' => [
          { gem_name: 'minor_gem', new_version: '1.1.0', previous_version: '1.0.0', platform: nil }
        ],
        'patch' => [
          { gem_name: 'patch_gem', new_version: '1.0.1', previous_version: '1.0.0', platform: nil }
        ],
        'new' => [
          { gem_name: 'new_gem', new_version: '1.0.0', previous_version: nil, platform: nil }
        ]
      }.to_json
    end

    it 'generates the correct JSON output' do
      output = described_class.generate_output(categorized_gems)
      expect(output).to eq(expected_output)
    end
  end
end
