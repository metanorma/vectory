require "spec_helper"

RSpec.describe Vectory::Svg do
  describe "#to_emf" do
    let(:input) { "spec/examples/svg2emf/img.svg" }
    let(:reference) { "spec/examples/svg2emf/img.emf" }

    it "returns emf content" do
      expect(Vectory::Svg.from_path(input).to_emf.content)
        .to be_equivalent_to File.read(reference)
    end
  end
end
