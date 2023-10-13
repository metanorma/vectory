# frozen_string_literal: true

module Vectory
  class Eps < Vector
    def self.default_extension
      "eps"
    end

    def self.mimetype
      "application/postscript"
    end

    def to_ps
      convert_with_inkscape("--export-type=ps", Ps)
    end

    def to_svg
      convert_with_inkscape("--export-plain-svg --export-type=svg", Svg)
    end

    def to_emf
      convert_with_inkscape("--export-type=emf", Emf)
    end

    private

    def imgfile_suffix(uri, suffix)
      "#{File.join(File.dirname(uri), File.basename(uri, '.*'))}.#{suffix}"
    end
  end
end
