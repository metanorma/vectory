# frozen_string_literal: true

require "tmpdir"
require_relative "inkscape_converter"

module Vectory
  class Eps < Image
    def to_svg
      Dir.mktmpdir do |dir|
        eps_path = File.join(dir, "image.eps")
        File.binwrite(eps_path, @content)

        InkscapeConverter.instance.convert(eps_path, nil, "--export-plain-svg --export-type=svg")
        svg_path = "#{eps_path}.svg"

        Svg.from_path(svg_path)
      end
    end

    private

    def imgfile_suffix(uri, suffix)
      "#{File.join(File.dirname(uri), File.basename(uri, '.*'))}.#{suffix}"
    end
  end
end
