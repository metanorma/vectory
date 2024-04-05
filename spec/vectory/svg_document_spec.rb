require "spec_helper"

RSpec.describe Vectory::SvgDocument do
  describe "#remap_links" do
    let(:input) { "spec/examples/svg2eps/img.svg" }

    context "remapped links beforehand" do
      it "converts successfully" do
        document = Vectory::SvgDocument.new(File.read(input))

        expect { document.remap_links({}) }.not_to raise_error
      end
    end
  end
end
