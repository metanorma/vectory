require "spec_helper"
require "vectory/cli"

RSpec.describe Vectory::CLI do
  before do
    allow(Vectory.ui).to receive(:fatal)
    allow(Vectory.ui).to receive(:error)
    allow(Vectory.ui).to receive(:warn)
    allow(Vectory.ui).to receive(:info)
    allow(Vectory.ui).to receive(:debug)
  end

  describe "#convert" do
    shared_examples "converter" do |format|
      it "creates file of a chosen format" do
        matcher = format == "eps" ? "be_equivalent_eps_to" : "be_equivalent_to"
        with_tmp_dir do |dir|
          output = File.join(dir, "output.#{format}")
          status = described_class.start(["-f", format, "-o", output, input])
          expect(status).to be Vectory::CLI::STATUS_SUCCESS
          expect(File.read(output))
            .to public_send(matcher, File.read(reference))
        end
      end
    end

    context "eps to svg" do
      let(:input)     { "spec/examples/eps2svg/img.eps" }
      let(:reference) { "spec/examples/eps2svg/img.svg" }

      it_behaves_like "converter", "svg"
    end

    context "eps to emf" do
      let(:input)     { "spec/examples/eps2emf/img.eps" }
      let(:reference) { "spec/examples/eps2emf/img.emf" }

      it_behaves_like "converter", "emf"
    end

    context "svg to emf" do
      let(:input)     { "spec/examples/svg2emf/img.svg" }
      let(:reference) { "spec/examples/svg2emf/img.emf" }

      it_behaves_like "converter", "emf"
    end

    context "emf to svg" do
      let(:input)     { "spec/examples/emf2svg/img.emf" }
      let(:reference) { "spec/examples/emf2svg/img.svg" }

      it_behaves_like "converter", "svg"
    end

    context "emf to eps" do
      let(:input)     { "spec/examples/emf2eps/img.emf" }
      let(:reference) { "spec/examples/emf2eps/img.eps" }

      it_behaves_like "converter", "eps"
    end

    context "jpg to svg" do
      let(:input)  { "spec/examples/img.jpg" }
      let(:format) { "svg" }

      it "returns unsupported-input-format error" do
        with_tmp_dir do |dir|
          expect(Vectory.ui).to receive(:error)
            .with(start_with("Could not detect input format. " \
                             "Please provide file of the following formats:"))

          output = File.join(dir, "output.#{format}")
          status = described_class.start(["-f", format, "-o", output, input])

          expect(status)
            .to be Vectory::CLI::STATUS_UNSUPPORTED_INPUT_FORMAT_ERROR
        end
      end
    end

    context "svg to jpg" do
      let(:input)  { "spec/examples/svg2emf/img.svg" }
      let(:format) { "jpg" }

      it "returns unsupported-output-format error" do
        with_tmp_dir do |dir|
          expect(Vectory.ui).to receive(:error)
            .with(start_with("Unsupported output format '#{format}'. " \
                             "Please choose one of:"))

          output = File.join(dir, "output.#{format}")
          status = described_class.start(["-f", format, "-o", output, input])

          expect(status)
            .to be Vectory::CLI::STATUS_UNSUPPORTED_OUTPUT_FORMAT_ERROR
        end
      end
    end
  end
end
