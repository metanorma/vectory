# frozen_string_literal: true

require_relative "inkscape_converter"

module Vectory
  class Eps < Image
    def to_svg
      Dir.mktmpdir do |dir|
        # TODO: replace with initial file name
        eps = File.join(dir, "image.eps")
        File.binwrite(eps, @content)
        svg = File.join(dir, "image.svg")
        InkscapeConverter.instance.convert(eps, svg, "--export-plain-svg")
        content = File.read(svg)
        Svg.from_content(content)
      end
    end

    private

    def imgfile_suffix(uri, suffix)
      "#{File.join(File.dirname(uri), File.basename(uri, '.*'))}.#{suffix}"
    end
  end
end
