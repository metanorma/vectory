require "thor"
require_relative "../vectory"

module Vectory
  class CLI < Thor
    STATUS_SUCCESS = 0
    STATUS_UNKNOWN_ERROR = 1
    STATUS_UNSUPPORTED_FORMAT_ERROR = 2

    module SupportedFormats
      SVG = "svg".freeze
      EMF = "emf".freeze

      def self.all
        constants.map { |x| const_get(x) }
      end
    end

    def self.exit_on_failure?
      false
    end

    desc "convert INPUT_FILE_NAME",
         "Perform pairwise vector image conversions for common vector image " \
         "formats (EPS, PS, EMF, SVG)"
    option :format,
           aliases: :f,
           required: true,
           desc: "the desired output format (one of: svg, eps, ps, emf)"

    # TODO: make the output flag optional
    option :output,
           aliases: :o,
           required: true,
           desc: "file path to the desired output file (with the file " \
                 "extension)"
    def convert(file)
      unless supported_format?(options[:format])
        return unsupported_format_error(options[:format])
      end

      object = source_object(file, options)

      convert_to_format(object, options)
    end
    default_task :convert

    private

    def supported_format?(format)
      SupportedFormats.all.include?(format)
    end

    def unsupported_format_error(format)
      formats = SupportedFormats.all.map { |v| "'#{v}'" }.join(", ")

      Vectory.ui.error(
        "Unsupported format: '#{format}'. Please choose one of: #{formats}.",
      )

      STATUS_UNSUPPORTED_FORMAT_ERROR
    end

    def source_object(file, options)
      # TODO: detect source format
      case options[:format]
      when SupportedFormats::SVG
        Vectory::Eps.from_path(file)
      when SupportedFormats::EMF
        Vectory::Svg.from_path(file)
      end
    end

    def convert_to_format(object, options)
      path = to_format(object, options[:format]).write(options[:output]).path
      Vectory.ui.info("Output file was written to #{path}")
      STATUS_SUCCESS
    end

    def to_format(object, format)
      method_name = "to_#{format}"
      object.public_send(method_name)
    end
  end
end
