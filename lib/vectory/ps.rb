# frozen_string_literal: true

module Vectory
  class Ps < Vector
    def self.default_extension
      "ps"
    end

    def self.mimetype
      "application/postscript"
    end

    def self.from_node(node)
      return from_content(node.children.to_xml) unless node.text.strip.empty?

      uri = node["src"]
      return Vectory::Datauri.new(uri).to_vector if %r{^data:}.match?(uri)

      from_path(uri)
    end

    def to_eps
      convert_with_inkscape("--export-type=eps", Eps)
    end

    def to_emf
      convert_with_inkscape("--export-type=emf", Emf)
    end

    def to_svg
      convert_with_inkscape("--export-type=svg", Svg)
    end
  end
end
