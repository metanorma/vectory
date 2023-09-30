# frozen_string_literal: true

require "emf2svg"

module Vectory
  class Emf < Image
    def to_svg
      with_file("emf") do |input_path|
        content = Emf2svg.from_file(input_path).sub(/<\?[^>]+>/, "")

        Svg.from_content(content)
      end
    end
  end
end
