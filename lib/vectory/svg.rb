# frozen_string_literal: true

module Vectory
  class Svg < Image
    SVG = { "m" => "http://www.w3.org/2000/svg" }.freeze

    def to_emf
      Dir.mktmpdir do |dir|
        svg = File.join(dir, "image.svg")
        File.binwrite(svg, @content)
        emf = File.join(dir, "image.emf")
        InkscapeConverter.instance.convert(svg, emf, '--export-type="emf"')
        content = File.read(emf)
        Emf.from_content(content)
      end
    end

    def to_emf_uri_convert(node)
      if node.elements&.first&.name == "svg"
        a = Base64.strict_encode64(node.children.to_xml)
        "data:image/svg+xml;base64,#{a}"
      else
        node["src"]
      end
    end


  end
end
