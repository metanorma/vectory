# frozen_string_literal: true

module Vectory
  class Svg < Image
    SVG = { "m" => "http://www.w3.org/2000/svg" }.freeze

    def self.default_extension
      "svg"
    end

    def to_emf
      convert_with_inkscape("--export-type=emf", Emf)
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
