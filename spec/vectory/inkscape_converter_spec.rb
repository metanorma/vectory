require "spec_helper"

RSpec.describe Vectory::InkscapeConverter do
  describe "#convert " do
    context "file has inproper format" do
      context "svg extension, but eps content" do
        let(:input) { "spec/examples/eps_but_svg_extension.svg" }

        let(:command) do
          Vectory::InkscapeConverter.convert(input, "svg", "--export-type=eps")
        end

        it "raises error" do
          expect { command }.to raise_error(Vectory::ConversionError,
                                            /parser error : Start tag expected/)
        end
      end
    end
  end
end
