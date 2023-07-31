require "spec_helper"

RSpec.describe Vectory::Svg do
  describe "#to_emf" do
    let(:input) { File.read('spec/examples/file3.svg') }
    let(:reference) { File.read('spec/references/file3.emf') }

    xit "returns emf content" do
      expect(Vectory::Svg.from_content(input).to_emf.content)
        .to be_equivalent_to reference
    end
  end
end
