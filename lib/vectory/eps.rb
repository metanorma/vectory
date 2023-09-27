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
      with_tmp_dir do |dir|
        eps_path = File.join(dir, "image.eps")
        File.binwrite(eps_path, @content)

        InkscapeConverter.instance.convert(eps_path, nil, inkscape_options)
        output_path = "#{eps_path}.#{output_extension}"

        target_class.from_path(output_path)
      end
    end

    def with_tmp_dir(&block)
      Dir.mktmpdir(&block)
    end

    def imgfile_suffix(uri, suffix)
      "#{File.join(File.dirname(uri), File.basename(uri, '.*'))}.#{suffix}"
    end
  end
end
