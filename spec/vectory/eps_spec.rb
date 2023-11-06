require "spec_helper"

RSpec.describe Vectory::Eps do
  shared_examples "converter" do |format|
    it "returns content of a chosen format" do
      matcher = case format
                when "eps", "ps" then "be_equivalent_eps_to"
                when "svg" then "be_equivalent_svg_to"
                else "be_equivalent_to"
                end

      to_format_method = "to_#{format}"
      expect(described_class.from_path(input)
                            .public_send(to_format_method)
                            .content)
        .to public_send(matcher, File.read(reference))
    end
  end

  describe "#to_ps" do
    let(:input)     { "spec/examples/eps2ps/img.eps" }
    let(:reference) { "spec/examples/eps2ps/ref.ps" }

    it_behaves_like "converter", "ps"
  end

  describe "#to_svg" do
    let(:input)     { "spec/examples/eps2svg/img.eps" }
    let(:reference) { "spec/examples/eps2svg/ref.svg" }

    it_behaves_like "converter", "svg"
  end

  describe "#to_emf" do
    let(:input)     { "spec/examples/eps2emf/img.eps" }
    let(:reference) { "spec/examples/eps2emf/ref.emf" }

    it_behaves_like "converter", "emf"
  end
end
