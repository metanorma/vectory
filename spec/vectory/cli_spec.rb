require "spec_helper"
require "vectory/cli"

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
        end
      end
    end

    context "svg to emf" do
      let(:input)     { "spec/examples/svg2emf/img.svg" }
      let(:reference) { "spec/examples/svg2emf/img.emf" }

      it "writes emf file" do
        spec_dir do |dir|
          output = File.join(dir, "output.emf")
          status = described_class.start(["-f", "emf",
                                          "-o", output,
                                          "spec/examples/svg2emf/img.svg"])
          expect(status).to be Vectory::CLI::STATUS_SUCCESS
          expect(File.read(output))
            .to be_equivalent_to File.read(reference)
        end
      end
    end
  end
end
