# frozen_string_literal: true

require "spec_helper"
# Assuming the module is loaded correctly by spec_helper or via a direct require
# If not, you might need:
require_relative '../../lib/vectory/image_sizer'

RSpec.describe Vectory do
  describe ".image_size_percent" do
    context "when calculating percentages" do
      it "correctly calculates pixel value from percentage and real dimension" do
        expect(described_class.image_size_percent(50.0, 200)).to eq(100.0)
      end

      it "returns nil if real_dimension is nil" do
        expect(described_class.image_size_percent(50.0, nil)).to be_nil
      end

      it "returns nil if percentage_numeric_value is nil" do
        expect(described_class.image_size_percent(nil, 200)).to be_nil
      end

      it "handles floating point percentages" do
        expect(described_class.image_size_percent(33.3, 300)).to be_within(0.01).of(99.9)
      end
    end
  end

  describe ".css_size_to_px" do
    let(:default_dpi) { 96 }
    let(:real_dimension_200) { 200 }

    context "with valid pixel units" do
      it "converts '100px' to 100" do
        expect(described_class.css_size_to_px("100px", real_dimension_200, dpi: default_dpi)).to eq(100)
      end
      it "converts '150.7px' to 150 (integer conversion)" do
        expect(described_class.css_size_to_px("150.7px", real_dimension_200, dpi: default_dpi)).to eq(150)
      end
    end

    context "with valid physical units and default DPI (96)" do
      it "converts '1in' to 96" do
        expect(described_class.css_size_to_px("1in", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
      it "converts '2.54cm' to 96" do
        # 2.54 cm * 96 dpi / 2.54 cm/in = 96
        expect(described_class.css_size_to_px("2.54cm", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
      it "converts '25.4mm' to 96" do
        # 25.4 mm * 96 dpi / 25.4 mm/in = 96
        expect(described_class.css_size_to_px("25.4mm", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
      it "converts '72pt' to 96" do
        # 72 pt * 96 dpi / 72 pt/in = 96
        expect(described_class.css_size_to_px("72pt", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
      it "converts '6pc' to 96" do
        # 6 pc * 12 pt/pc * 96 dpi / 72 pt/in = 96
        expect(described_class.css_size_to_px("6pc", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
    end

    context "with valid physical units and custom DPI" do
      let(:custom_dpi) { 300 }
      it "converts '1in' to 300 with 300 DPI" do
        expect(described_class.css_size_to_px("1in", real_dimension_200, dpi: custom_dpi)).to eq(300)
      end
      it "converts '1cm' to approx 118 with 300 DPI" do
        # 1 cm * 300 dpi / 2.54 cm/in = 118.11...
        expect(described_class.css_size_to_px("1cm", real_dimension_200, dpi: custom_dpi)).to eq(118)
      end
    end

    context "with percentage units" do
      it "converts '50%' of 200 to 100" do
        expect(described_class.css_size_to_px("50%", real_dimension_200, dpi: default_dpi)).to eq(100)
      end
      it "converts '25.5%' of 100 to 25 (integer conversion)" do
        # 100 * (25.5 / 100.0) = 25.5 -> 25.to_i
        expect(described_class.css_size_to_px("25.5%", 100, dpi: default_dpi)).to eq(25)
      end
      it "returns nil for '%' if real_dimension_for_percentage is nil" do
        expect(described_class.css_size_to_px("50%", nil, dpi: default_dpi)).to be_nil
      end
    end

    context "with plain numbers (interpreted as pixels)" do
      it "converts '150' to 150" do
        expect(described_class.css_size_to_px("150", real_dimension_200, dpi: default_dpi)).to eq(150)
      end
      it "converts '200.7' to 200 (integer conversion)" do
        expect(described_class.css_size_to_px("200.7", real_dimension_200, dpi: default_dpi)).to eq(200)
      end
    end

    context "with string variations" do
      it "handles leading/trailing spaces: ' 100px '" do
        expect(described_class.css_size_to_px(" 100px ", real_dimension_200, dpi: default_dpi)).to eq(100)
      end
      it "handles case-insensitive units: '1IN'" do
        expect(described_class.css_size_to_px("1IN", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
      it "handles '2.54CM'" do
        expect(described_class.css_size_to_px("2.54CM", real_dimension_200, dpi: default_dpi)).to eq(96)
      end
    end

    context "with invalid or edge case inputs" do
      it "returns nil for nil input" do
        expect(described_class.css_size_to_px(nil, real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "returns nil for empty string ''" do
        expect(described_class.css_size_to_px("", real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "returns nil for 'auto'" do
        expect(described_class.css_size_to_px("auto", real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "returns nil for unknown unit '10em'" do
        expect(described_class.css_size_to_px("10em", real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "returns nil for malformed string 'abc'" do
        expect(described_class.css_size_to_px("abc", real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "returns nil for malformed string '100 px' (space before unit)" do
        expect(described_class.css_size_to_px("100 px", real_dimension_200, dpi: default_dpi)).to be_nil
      end
       it "returns nil for malformed string 'px100'" do
        expect(described_class.css_size_to_px("px100", real_dimension_200, dpi: default_dpi)).to be_nil
      end
      it "parses negative values like '-10px' to -10" do
        expect(described_class.css_size_to_px("-10px", real_dimension_200, dpi: default_dpi)).to eq(-10)
      end
    end
  end

  describe ".image_size_interpret" do
    let(:default_dpi) { 96 }

    context "with basic pixel units" do
      it "interprets {'width' => '100px', 'height' => '50px'}" do
        img = { "width" => "100px", "height" => "50px" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([100, 50])
      end
    end

    context "with physical units and default DPI" do
      it "interprets {'width' => '2in', 'height' => '1in'}" do
        img = { "width" => "2in", "height" => "1in" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([192, 96])
      end
      it "interprets {'width' => '2.54cm', 'height' => '5.08cm'}" do
        img = { "width" => "2.54cm", "height" => "5.08cm" } # 1 inch, 2 inches
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([96, 192])
      end
    end

    context "with percentage units" do
      it "interprets {'width' => '50%', 'height' => '25%'} with realsize [200, 400]" do
        img = { "width" => "50%", "height" => "25%" }
        realsize = [200, 400]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([100, 100])
      end
      it "interprets {'width' => '50%'} with realsize [200, nil]" do
        img = { "width" => "50%" }
        realsize = [200, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([100, nil])
      end
      it "interprets {'height' => '25%'} with realsize [nil, 400]" do
        img = { "height" => "25%" }
        realsize = [nil, 400]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([nil, 100])
      end
      it "interprets percentages with nil realsize" do
        img = { "width" => "50%", "height" => "25%" }
        expect(described_class.image_size_interpret(img, nil, dpi: default_dpi)).to eq([nil, nil])
        expect(described_class.image_size_interpret(img, [], dpi: default_dpi)).to eq([nil, nil])
      end
    end

    context "with mixed units" do
      it "interprets {'width' => '150px', 'height' => '50%'} with realsize [nil, 200]" do
        img = { "width" => "150px", "height" => "50%" }
        realsize = [nil, 200]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([150, 100])
      end
    end

    context "with missing width/height attributes" do
      it "interprets {'width' => '100px'}" do
        img = { "width" => "100px" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([100, nil])
      end
      it "interprets {'height' => '50px'}" do
        img = { "height" => "50px" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([nil, 50])
      end
      it "interprets {} (empty img hash)" do
        img = {}
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([nil, nil])
      end
    end

    context "with 'auto' values" do
      it "interprets {'width' => 'auto', 'height' => '100px'}" do
        img = { "width" => "auto", "height" => "100px" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: default_dpi)).to eq([nil, 100])
      end
    end

    context "with different DPI values" do
      it "interprets {'width' => '1in'} with DPI 72" do
        img = { "width" => "1in" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: 72)).to eq([72, nil])
      end
      it "interprets {'width' => '1in'} with DPI 300" do
        img = { "width" => "1in" }
        realsize = [nil, nil]
        expect(described_class.image_size_interpret(img, realsize, dpi: 300)).to eq([300, nil])
      end
    end

    context "with original issue values" do
      it "correctly interprets height='13.5cm' width='16.36cm' at 96 DPI" do
        img = { "height" => "13.5cm", "width" => "16.36cm" }
        realsize = [nil, nil] # Assuming no parent context for percentage
        # width: 16.36cm * 96dpi / 2.54cm/in = 1570.56 / 2.54 = 618.33... -> 618 (rounded)
        # height: 13.5cm * 96dpi / 2.54cm/in = 1296 / 2.54 = 510.23... -> 510 (rounded)
        expect(described_class.image_size_interpret(img, realsize, dpi: 96)).to eq([618, 510])
      end

      it "correctly interprets height='13.5cm' width='16.36cm' at 300 DPI" do
        img = { "height" => "13.5cm", "width" => "16.36cm" }
        realsize = [nil, nil]
        # width: 16.36 * 300 / 2.54 = 4808 / 2.54 = 1932.28... -> 1932 (rounded)
        # height: 13.5 * 300 / 2.54 = 4050 / 2.54 = 1594.48... -> 1594 (rounded)
        expect(described_class.image_size_interpret(img, realsize, dpi: 300)).to eq([1932, 1594])
      end
    end
  end
end