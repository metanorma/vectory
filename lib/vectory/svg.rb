# frozen_string_literal: true

module Vectory
  class Svg < Image
    SVG = { "m" => "http://www.w3.org/2000/svg" }.freeze

    def to_emf
      Dir.mktmpdir do |dir|
        svg_path = File.join(dir, "image.svg")
        File.binwrite(svg_path, @content)

        InkscapeConverter.instance.convert(svg_path, nil, '--export-type="emf"')
        emf_path = "#{svg_path}.emf"

        Emf.from_path(emf_path)
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
