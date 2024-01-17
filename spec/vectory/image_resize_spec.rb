require "spec_helper"

RSpec.describe Vectory::ImageResize do
  let(:instance) { described_class.new }

  it "resizes images with missing or auto sizes" do
    image = Nokogiri::XML("<img src='spec/examples/19160-8.jpg'/>").root
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
    image["width"] = "20"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [20, 65]
    image.delete("width")
    image["height"] = "50"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [15, 50]
    image.delete("height")
    image["width"] = "500"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
    image.delete("width")
    image["height"] = "500"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
    image["width"] = "20"
    image["height"] = "auto"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [20, 65]
    image["width"] = "auto"
    image["height"] = "50"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [15, 50]
    image["width"] = "500"
    image["height"] = "auto"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
    image["width"] = "auto"
    image["height"] = "500"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
    image["width"] = "auto"
    image["height"] = "auto"
    expect(instance.call(image, "spec/examples/19160-8.jpg", 100, 100))
      .to eq [30, 100]
  end

  it "converts percentage sizes of images" do
    image = Nokogiri::XML("<img src='spec/examples/19160-8.jpg'/>").root
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[919, 3000], [919, 3000]]
    image["width"] = "20.4"
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[20, 0], [919, 3000]]
    image["height"] = "auto"
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[20, 0], [919, 3000]]
    image.delete("width")
    image["height"] = "20.4"
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[0, 20], [919, 3000]]
    image["width"] = "auto"
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[0, 20], [919, 3000]]
    image["height"] = "30%"
    image["width"] = "50%"
    expect(instance.get_image_size(image, "spec/examples/19160-8.jpg"))
      .to eq [[459, 900], [919, 3000]]
  end

  it "resizes SVG with missing or auto sizes" do
    image = Nokogiri::XML(File.read("spec/examples/odf.svg")).root
    instance.call(image, "spec/examples/odf.svg", 100, 100)
    expect(image.attributes["viewBox"].value).to eq "0 0 100 100"
  end
end
