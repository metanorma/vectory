require "spec_helper"

RSpec.describe Vectory::Eps do
  describe "#to_svg" do
    it "returns svg content" do
      Dir.mktmpdir(nil, Vectory.root_path.join("tmp/")) do |dir|
        expect(xmlpp(strip_guid(
          Vectory::Eps.from_path("spec/examples/eps2svg/img.eps")
            .to_svg
            .content
            .sub(%r{<localized-strings>.*</localized-strings>}m, "")
            .gsub(%r{src="[^"]+?\.emf"}, 'src="_.emf"')
            .gsub(%r{src="[^"]+?\.svg"}, 'src="_.svg"')
        ))).to be_equivalent_to (File.read("spec/examples/eps2svg/img.svg"))
      end
    end
  end
end
