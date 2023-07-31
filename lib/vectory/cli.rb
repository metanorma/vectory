require "thor"
require_relative "../vectory"

module Vectory
  class CLI < Thor
    STATUS_SUCCESS = 0
    STATUS_UNKNOWN_ERROR = 1

    def self.exit_on_failure?
      false
    end

    desc "convert INPUT_FILE_NAME", "Perform pairwise vector image conversions for common vector image formats (EPS, PS, EMF, SVG)"
    option :format, aliases: :f, desc: "the desired output format (one of: svg, eps, ps, emf)", required: true
    option :output, aliases: :o, desc: "file path to the desired output file (with the file extension)"
    def convert(file)
      Vectory.convert_to_svg(file, options[:output])
      STATUS_SUCCESS
    end
    default_task :convert
  end
end
