# frozen_string_literal: true

module Vectory
  class Svg < Vector
    SVG = { "m" => "http://www.w3.org/2000/svg" }.freeze

    def self.default_extension
      "svg"
    end

    def self.mimetype
      "image/svg+xml"
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
  end
end
