require "spec_helper"

RSpec.describe Vectory::Svg do
  describe "#to_emf" do
    let(:input)     { "spec/examples/svg2emf/img.svg" }
    let(:reference) { "spec/examples/svg2emf/ref.emf" }

    it "returns emf content" do
      expect(Vectory::Svg.from_path(input).to_emf.content)
        .to be_equivalent_to File.read(reference)
    end
  end

  describe "#to_eps" do
    let(:input)     { "spec/examples/svg2eps/img.svg" }
    let(:reference) { "spec/examples/svg2eps/ref.eps" }

    it "returns eps content" do
      expect(Vectory::Svg.from_path(input).to_eps.content)
        .to be_equivalent_eps_to File.read(reference)
    end

    context "remapped links beforehand" do
      it "converts successfully" do
        vector = Vectory::Svg.from_path(input)
        vector.remap_links({})
        expect { vector.to_eps }.not_to raise_error
      end
    end
  end

  describe "#to_ps" do
    let(:input)     { "spec/examples/svg2ps/img.svg" }
    let(:reference) { "spec/examples/svg2ps/ref.ps" }

    it "returns ps content" do
      expect(Vectory::Svg.from_path(input).to_ps.content)
        .to be_equivalent_eps_to File.read(reference)
    end
  end
end
