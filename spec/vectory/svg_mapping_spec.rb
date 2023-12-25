require "spec_helper"

RSpec.describe Vectory::SvgMapping do
  context "no namespace" do
    let(:source) { Vectory::SvgMapping.from_path("doc.xml") }
    let(:reference) { File.read("doc-ref.xml") }
    let(:work_dir) { "spec/examples/svg" }

    it "rewrites ids" do
      Dir.chdir(work_dir) do
        content = source.to_xml

        expect(xmlpp(strip_image_and_style(content)))
          .to be_equivalent_to xmlpp(reference)
      end
    end
  end

  context "with namespaces" do
    let(:source) { Vectory::SvgMapping.from_path("doc2.xml") }
    let(:reference) { File.read("doc2-ref.xml") }
    let(:work_dir) { "spec/examples/svg" }

    it "rewrites ids" do
      Dir.chdir(work_dir) do
        content = source.to_xml

        expect(xmlpp(strip_image(content)))
          .to be_equivalent_to xmlpp(reference)
      end
    end
  end

  def strip_image(xml)
    xml.gsub(%r{<image.*?</image>}m, "<image/>")
  end

  def strip_image_and_style(xml)
    xml.gsub(%r{<image.*?</image>}m, "<image/>")
       .gsub(%r{<style.*?</style>}m, "<style/>") # rubocop:disable Layout/MultilineMethodCallIndentation
  end
end
