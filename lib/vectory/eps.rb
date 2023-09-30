# frozen_string_literal: true

require_relative "inkscape_converter"

module Vectory
  class Eps < Image
    def to_svg
      convert_with_inkscape("--export-plain-svg --export-type=svg", "svg", Svg)
    end

    def to_emf
      convert_with_inkscape("--export-type=emf", "emf", Emf)
    end

    private

    def convert_with_inkscape(inkscape_options, output_extension, target_class)
      with_file("eps") do |input_path|
        InkscapeConverter.instance.convert(input_path, nil, inkscape_options)
        output_path = "#{input_path}.#{output_extension}"

        target_class.from_path(output_path)
      end
    end

    def imgfile_suffix(uri, suffix)
      "#{File.join(File.dirname(uri), File.basename(uri, '.*'))}.#{suffix}"
    end
  end
end
