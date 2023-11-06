require "spec_helper"

RSpec.describe Vectory::InkscapeConverter do
  describe "#convert " do
    context "file has inproper format: svg extension, but eps content" do
      let(:input) { "spec/examples/eps_but_svg_extension.svg" }

      it "raises error" do
        with_tmp_dir do |dir|
          tmp_input_path = File.join(dir, File.basename(input))
          FileUtils.cp(input, tmp_input_path)

          expect do
            Vectory::InkscapeConverter.convert(tmp_input_path,
                                               "emf",
                                               "--export-type=emf")
          end.to raise_error(Vectory::ConversionError,
                             /parser error : Start tag expected/)
        end
      end
    end

    context "inkscape is not installed" do
      let(:input) { "spec/examples/eps2svg/img.eps" }

      it "raises error" do
        with_tmp_dir do |dir|
          tmp_input_path = File.join(dir, "image.eps")
          FileUtils.cp(input, tmp_input_path)

          expect(Vectory::InkscapeConverter.instance)
            .to receive(:inkscape_path).and_return(nil)

          expect do
            Vectory::InkscapeConverter.convert(tmp_input_path,
                                               "svg",
                                               "--export-type=svg")
          end.to raise_error(Vectory::InkscapeNotFoundError)
        end
      end
    end
  end
end
