# frozen_string_literal: true

module Vectory
  class Ps < Vector
    def self.default_extension
      "ps"
    end

    def self.mimetype
      "application/postscript"
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
