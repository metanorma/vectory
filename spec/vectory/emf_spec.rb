require "spec_helper"

RSpec.describe Vectory::Emf do
  describe "#to_svg" do
    let(:input)     { "spec/examples/emf2svg/img.emf" }
    let(:reference) { "spec/examples/emf2svg/img.svg" }

    it "returns svg content" do
      expect(Vectory::Emf.from_path(input).to_svg.content)
        .to be_equivalent_to File.read(reference)
    end

    it "strips the starting xml tag" do
      expect(Vectory::Emf.from_path(input).to_svg.content)
        .not_to start_with "<?xml"
    end
  end
end
