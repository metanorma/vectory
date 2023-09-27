require "spec_helper"

RSpec.describe Vectory::Eps do
  shared_examples "converter" do |format|
    it "returns content of a chosen format" do
      to_format_method = "to_#{format}"
      expect(described_class.from_path(input)
                            .public_send(to_format_method)
                            .content)
        .to be_equivalent_to (File.read(reference))
    end
  end

  describe "#to_svg" do
    let(:input)     { "spec/examples/eps2svg/img.eps" }
    let(:reference) { "spec/examples/eps2svg/img.svg" }

    it_behaves_like "converter", "svg"
  end

  describe "#to_emf" do
    let(:input)     { "spec/examples/eps2emf/img.eps" }
    let(:reference) { "spec/examples/eps2emf/img.emf" }

    it_behaves_like "converter", "emf"
  end
end
