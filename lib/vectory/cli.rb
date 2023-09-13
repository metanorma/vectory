require "thor"
require_relative "../vectory"

module Vectory
  class CLI < Thor
    STATUS_SUCCESS = 0
    STATUS_UNKNOWN_ERROR = 1
    STATUS_UNSUPPORTED_FORMAT_ERROR = 2

    SUPPORTED_FORMATS = { svg: "svg" }

    def self.exit_on_failure?
      false
    end

    desc "convert INPUT_FILE_NAME", "Perform pairwise vector image conversions for common vector image formats (EPS, PS, EMF, SVG)"
    option :format, aliases: :f, desc: "the desired output format (one of: svg, eps, ps, emf)", required: true

    # TODO: make the output flag optional
    option :output, aliases: :o, desc: "file path to the desired output file (with the file extension)", required: true
    def convert(file)
      case options[:format]
      when SUPPORTED_FORMATS[:svg]
        eps = Vectory::Eps.from_path(file)
        path = eps.to_svg.write(options[:output]).path
        Vectory.ui.info("Output file was written to #{path}")
        STATUS_SUCCESS
      else
        formats = SUPPORTED_FORMATS.values.map { |v| "'#{v}'" }.join(', ')
        Vectory.ui.error(
          "Unsupported format: '#{options[:format]}'. " \
          "Please choose one of: #{formats}."
        )
        STATUS_UNSUPPORTED_FORMAT_ERROR
      end
    end
    default_task :convert
  end
end
