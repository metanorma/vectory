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

  describe "#to_eps" do
    let(:input)     { "spec/examples/emf2eps/img.emf" }
    let(:reference) { "spec/examples/emf2eps/img.eps" }

    it "returns eps content" do
      expect(Vectory::Emf.from_path(input).to_eps.content)
        .to be_equivalent_eps_to File.read(reference)
    end
  end
end
