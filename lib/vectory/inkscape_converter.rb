# frozen_string_literal: true

require "singleton"
require_relative "system_call"

module Vectory
  class InkscapeConverter
    include Singleton

    def self.convert(uri, output_extension, option)
      instance.convert(uri, output_extension, option)
    end

    def convert(uri, output_extension, option)
      exe = inkscape_path_or_raise_error
      uri = external_path uri
      exe = external_path exe
      cmd = %(#{exe} #{option} #{uri})

      call = SystemCall.new(cmd).call

      output_path = "#{uri}.#{output_extension}"
      raise_conversion_error(call) unless File.exist?(output_path)

      # and return Vectory::Utils::datauri(file)

      output_path
    end

    private

    def inkscape_path_or_raise_error
      installed? or raise "Inkscape missing in PATH, unable" \
                          "to convert image #{uri}. Aborting."
    end

    def installed?
      cmd = "inkscape"
      exts = ENV["PATHEXT"] ? ENV["PATHEXT"].split(";") : [""]

      ENV["PATH"].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end

      nil
    end

    def raise_conversion_error(call)
      raise Vectory::ConversionError,
            "Could not convert with Inkscape. " \
            "Inkscape cmd: '#{call.cmd}',\n" \
            "status: '#{call.status}',\n" \
            "stdout: '#{call.stdout.strip}',\n" \
            "stderr: '#{call.stderr.strip}'."
    end

    def external_path(path)
      win = !!((RUBY_PLATFORM =~ /(win|w)(32|64)$/) ||
               (RUBY_PLATFORM =~ /mswin|mingw/))
      if win
        path.gsub!(%{/}, "\\")
        path[/\s/] ? "\"#{path}\"" : path
      else
        path
      end
    end
  end
end
