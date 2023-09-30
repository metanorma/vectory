require "thor"
require_relative "../vectory"
require_relative "file_magic"

module Vectory
  class CLI < Thor
    STATUS_SUCCESS = 0
    STATUS_UNKNOWN_ERROR = 1
    STATUS_UNSUPPORTED_INPUT_FORMAT_ERROR = 2
    STATUS_UNSUPPORTED_OUTPUT_FORMAT_ERROR = 3

    module SupportedInputFormats
      EPS = :eps
      SVG = :svg
      EMF = :emf

      def self.all
        constants.map { |x| const_get(x) }
      end
    end

    module SupportedOutputFormats
      # EPS = "eps".freeze
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

      input_format = detect_input_format(file)
      unless supported_input_format?(input_format)
        return unsupported_input_format_error
      end

      object = source_object(file, input_format)

      convert_to_format(object, options)
    end
    default_task :convert

    private

    def supported_format?(format)
      SupportedOutputFormats.all.include?(format)
    end

    def unsupported_format_error(format)
      formats = SupportedOutputFormats.all.map { |v| "'#{v}'" }.join(", ")

      Vectory.ui.error(
        "Unsupported output format '#{format}'. " \
        "Please choose one of: #{formats}.",
      )

      STATUS_UNSUPPORTED_OUTPUT_FORMAT_ERROR
    end

    def detect_input_format(file)
      FileMagic.detect(file)
    end

    def supported_input_format?(format)
      SupportedInputFormats.all.include?(format)
    end

    def unsupported_input_format_error
      formats = SupportedInputFormats.all.map { |v| "'#{v}'" }.join(", ")
      Vectory.ui.error(
        "Could not detect input format. " \
        "Please provide file of the following formats: #{formats}.",
      )

      STATUS_UNSUPPORTED_INPUT_FORMAT_ERROR
    end

    def source_object(file, format)
      Vectory.const_get(format.capitalize).from_path(file)
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
