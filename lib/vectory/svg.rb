# frozen_string_literal: true

require "nokogiri"

module Vectory
  class Svg < Vector
    SVG_NS = "http://www.w3.org/2000/svg"

    def self.default_extension
      "svg"
    end

    def self.mimetype
      "image/svg+xml"
    end

    def self.from_node(node)
      if node.elements&.first&.name == "svg"
        return from_content(node.children.to_xml)
      end

      uri = node["src"]
      return Vectory::Datauri.new(uri).to_vector if %r{^data:}.match?(uri)

      from_path(uri)
    end

    def initialize(content = nil, initial_path = nil)
      super

      self.content = content
    end

    def to_emf
      convert_with_inkscape("--export-type=emf", Emf)
    end

    def to_eps
      convert_with_inkscape("--export-type=eps", Eps)
    end

    def to_ps
      convert_with_inkscape("--export-type=ps", Ps)
    end

    private

    def content=(content)
      # non-root node inserts the xml tag which breaks markup when placed in
      # another xml document
      document = Nokogiri::XML(content).root
      unless document
        raise ParsingError, "Could not parse '#{content&.slice(0, 30)}'"
      end

      @content = document.to_xml
    end
  end
end
