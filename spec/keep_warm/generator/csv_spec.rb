# frozen_string_literal: true

require 'rspec'
require 'csv'
require_relative '../../../lib/keep_warm/generator/csv'

RSpec.describe KeepWarm::Generator::CSV do
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
      'N/A' => [
        { gem_name: 'na_gem', new_version: '1.0.0', previous_version: nil, platform: nil }
      ]
    }
  end

  describe '.generate_output' do
    let(:expected_output) do
      CSV.generate(headers: true) do |csv|
        csv << ['Change Type', 'Gem Name', 'Previous Version', 'New Version', 'Platform']
        csv << ['Major', 'major_gem', '1.0.0', '2.0.0', nil]
        csv << ['Minor', 'minor_gem', '1.0.0', '1.1.0', nil]
        csv << ['Patch', 'patch_gem', '1.0.0', '1.0.1', nil]
        csv << ['N/A', 'na_gem', nil, '1.0.0', nil]
      end
    end

    it 'generates the correct CSV output' do
      output = described_class.generate_output(categorized_gems)
      expect(output).to eq(expected_output)
    end
  end
end
