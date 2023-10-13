# frozen_string_literal: true

require "emf2svg"

module Vectory
  class Emf < Vector
    def self.default_extension
      "emf"
    end

    def self.mimetype
      "image/emf"
    end

    def to_svg
      with_file("emf") do |input_path|
        content = Emf2svg.from_file(input_path).sub(/<\?[^>]+>/, "")

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
