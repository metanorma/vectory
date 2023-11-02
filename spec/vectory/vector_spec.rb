require "spec_helper"

RSpec.describe Vectory::Vector do
  describe "#to_uri" do
    let(:input) { "spec/examples/eps2emf/img.eps" }
    let(:vector) { Vectory::Eps.from_path(input) }

    it "returns Datauri object" do
      expect(vector.to_uri).to be_kind_of(Vectory::Datauri)
    end
  end

  describe "#write" do
    let(:image) { Vectory::Emf.from_path("spec/examples/emf2svg/img.emf") }

    context "no arg" do
      it "saves to a temporary directory" do
        expect(image.write.path).to include(Dir.tmpdir)
      end
    end

    context "path provided" do
      it "saves to the provided path" do
        Dir.mktmpdir do |tmp_dir|
          provided_path = File.join(tmp_dir, "image.emf")
          expect(image.write(provided_path).path).to eq provided_path
        end
      end
    end

    context "created from path and no arg provided" do
      it "saves to a temporary directory" do
        expect(image.write.path).to include(Dir.tmpdir)
      end
    end

    context "written two times without arg" do
      it "writes to the same path" do
        initial_path = image.write.path
        expect(image.write.path).to eq initial_path
      end
    end

    context "after conversion and no arg" do
      it "saves to a temporary directory" do
        expect(image.to_svg.write.path).to include(Dir.tmpdir)
      end
    end
  end

  describe "#path" do
    let(:image) { Vectory::Emf.from_path("spec/examples/emf2svg/img.emf") }

    context "created from path" do
      it "raises error that it is not written to disk" do
        expect { image.path }.to raise_error(Vectory::NotWrittenToDiskError)
      end
    end
  end
end
