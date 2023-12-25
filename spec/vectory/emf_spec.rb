require "spec_helper"

RSpec.describe Vectory::Emf do
  describe "#to_svg" do
    let(:input)     { "spec/examples/emf2svg/img.emf" }
    let(:reference) { "spec/examples/emf2svg/ref.svg" }

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
    let(:reference) { "spec/examples/emf2eps/ref.eps" }

    it "returns eps content" do
      expect(Vectory::Emf.from_path(input).to_eps.content)
        .to be_equivalent_eps_to File.read(reference)
    end
  end

  describe "#to_ps" do
    let(:input)     { "spec/examples/emf2ps/img.emf" }
    let(:reference) { "spec/examples/emf2ps/ref.ps" }

    it "returns ps content" do
      expect(Vectory::Emf.from_path(input).to_ps.content)
        .to be_equivalent_eps_to File.read(reference)
    end
  end

  describe "#mime" do
    let(:input) { "spec/examples/emf2eps/img.emf" }

    it "returns emf" do
      expect(described_class.from_path(input).mime).to eq "image/emf"
    end
  end

  describe "#height" do
    let(:input) { "spec/examples/emf2eps/img.emf" }

    it "returns height" do
      expect(described_class.from_path(input).height).to eq 90
    end
  end

  describe "#width" do
    let(:input) { "spec/examples/emf2eps/img.emf" }

    it "returns width" do
      expect(described_class.from_path(input).width).to eq 90
    end
  end

  describe "::from_node" do
    let(:node) { Nokogiri::XML(File.read(input)).child }
    let(:input) { "spec/examples/emf/datauri.xml" }

    it "can be converted to eps" do
      expect(described_class.from_node(node).to_eps).to be_kind_of(Vectory::Eps)
    end
  end
end
