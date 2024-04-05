# frozen_string_literal: true

require "emf2svg"

module Vectory
  class Emf < Vector
    def self.default_extension
      "emf"
    end

    def self.all_mimetypes
      [mimetype] + alternative_mimetypes
    end

    def self.mimetype
      "image/emf"
    end

    def self.alternative_mimetypes
      ["application/x-msmetafile"]
    end

    def self.from_node(node)
      uri = node["src"]
      return Vectory::Datauri.new(uri).to_vector if %r{^data:}.match?(uri)

      from_path(uri)
    end

    def to_svg
      with_file("emf") do |input_path|
        content = Emf2svg.from_file(input_path)

        Svg.from_content(content)
      end
    end

    def to_eps
      convert_with_inkscape("--export-type=eps", Eps)
    end

    def to_ps
      convert_with_inkscape("--export-type=ps", Ps)
    end
  end
end
