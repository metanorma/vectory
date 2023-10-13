require "spec_helper"

RSpec.describe Vectory::Vector do
  describe "#to_uri" do
    let(:input) { "spec/examples/eps2emf/img.eps" }
    let(:vector) { Vectory::Eps.from_path(input) }

    it "returns Datauri object" do
      expect(vector.to_uri).to be_kind_of(Vectory::Datauri)
    end
  end
end
