require "spec_helper"

require_relative "../../lib/vectory/file_magic"

RSpec.describe Vectory::FileMagic do
  describe "#detect" do
    references = {
      "spec/examples/eps2svg/img.eps" => :eps,
      "spec/examples/eps2emf/img.eps" => :eps,
      "spec/examples/eps2svg/img.svg" => :svg,
      "spec/examples/svg2emf/img.svg" => :svg,
      "spec/examples/eps2emf/img.emf" => :emf,
      "spec/examples/svg2emf/img.emf" => :emf,
    }

    references.each do |file, format|
      context file do
        it "returns #{format} format" do
          expect(described_class.detect(file)).to eq format
        end
      end
    end
  end
end
