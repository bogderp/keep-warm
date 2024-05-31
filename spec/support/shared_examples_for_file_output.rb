# frozen_string_literal: true

RSpec.shared_examples 'file output' do |format, extension, expected_output|
  let(:output_file) { "spec/fixtures/keep-warm-output.#{extension}" }

  before do
    KeepWarm.configure do |config|
      config.format = format
      config.output = :file
      config.output_dir = 'spec/fixtures'
    end
  end

  after do
    FileUtils.rm_f(output_file)
  end

  it "writes the #{format} to a file" do
    processor.run
    expect(File.read(output_file)).to eq(expected_output)
  end

  it 'outputs a confirmation message to standard output' do
    expect { processor.run }.to output("Writing to #{output_file}\nDone\n").to_stdout
  end
end
