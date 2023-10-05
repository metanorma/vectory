require "spec_helper"

RSpec.describe Vectory::Ps do
  describe "#to_eps" do
    let(:input)     { "spec/examples/ps2eps/img.ps" }
    let(:reference) { "spec/examples/ps2eps/img.eps" }

    it "returns eps content" do
      expect(Vectory::Ps.from_path(input).to_eps.content)
        .to be_equivalent_eps_to File.read(reference)
    end
  end

  describe "#to_emf" do
    let(:input)     { "spec/examples/ps2emf/img.ps" }
    let(:reference) { "spec/examples/ps2emf/img.emf" }

    it "returns emf content" do
      expect(Vectory::Ps.from_path(input).to_emf.content)
        .to be_equivalent_to File.read(reference)
    end
  end

  describe "#to_svg" do
    let(:input)     { "spec/examples/ps2svg/img.ps" }
    let(:reference) { "spec/examples/ps2svg/img.svg" }

    it "returns svg content" do
      expect(Vectory::Ps.from_path(input).to_svg.content)
        .to be_equivalent_svg_to File.read(reference)
    end
  end
end
