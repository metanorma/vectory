require "spec_helper"
require "vectory/cli"
require "tmpdir"

RSpec.describe Vectory::CLI do
  describe "#convert" do
    context "eps to svg" do
      xit "returns svg file" do
        Dir.mktmpdir(nil, Vectory.root_path.join("tmp/")) do |dir|
          output = File.join(dir, "file1.svg")
          status = described_class.start(["-f", "svg",
                                          "-o", output,
                                          "spec/examples/file1.eps"])
          expect(status).to be Vectory::CLI::STATUS_SUCCESS
          expect(File.read(output)).to eq File.read("spec/references/file1.svg")
          # expect(FileUtils.identical?(output, "spec/references/file1.svg")).to be true
        end
      end
    end
  end
end
