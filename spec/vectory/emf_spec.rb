require "spec_helper"

RSpec.describe Vectory::Emf do
  describe "#to_svg" do
    let(:input) { File.read('spec/examples/file2.emf') }
    let(:reference) { File.read('spec/references/file2.svg') }

    xit "returns svg content" do
      expect(Vectory::Emf.from_content(input).to_svg.content)
        .to be_equivalent_to reference
    end
  end
end
