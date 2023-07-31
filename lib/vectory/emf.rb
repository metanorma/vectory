# frozen_string_literal: true

require "emf2svg"

module Vectory
  class Emf < Image
    def to_svg
      Dir.mktmpdir do |dir|
        emf = File.join(dir, "image.emf")
        File.binwrite(emf, @content)
        content = Emf2svg.from_file(emf).sub(/<\?[^>]+>/, "")
        Svg.from_content(content)
      end
    end
  end
end
