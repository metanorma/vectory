# frozen_string_literal: true

require "singleton"
require "tmpdir"
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

      output_path = find_output(uri, output_extension)
      raise_conversion_error(call) unless output_path

      output_path
    end

    def height(content, format)
      query_integer(content, format, "--query-height")
    end

    def width(content, format)
      query_integer(content, format, "--query-width")
    end

    private

    def inkscape_path_or_raise_error
      inkscape_path or raise(InkscapeNotFoundError,
                             "Inkscape missing in PATH, unable to " \
                             "convert image. Aborting.")
    end

    def inkscape_path
      @inkscape_path ||= find_inkscape
    end

    def find_inkscape
      cmds.each do |cmd|
        extensions.each do |ext|
          paths.each do |path|
            exe = File.join(path, "#{cmd}#{ext}")

            return exe if File.executable?(exe) && !File.directory?(exe)
          end
        end
      end

      nil
    end

    def cmds
      ["inkscapecom", "inkscape"]
    end

    def extensions
      ENV["PATHEXT"] ? ENV["PATHEXT"].split(";") : [""]
    end

    def paths
      ENV["PATH"].split(File::PATH_SEPARATOR)
    end

    def find_output(source_path, output_extension)
      basenames = [File.basename(source_path, ".*"),
                   File.basename(source_path)]

      paths = basenames.map do |basename|
        "#{File.join(File.dirname(source_path), basename)}.#{output_extension}"
      end

      paths.find { |p| File.exist?(p) }
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

    def query_integer(content, format, options)
      query(content, format, options).to_f.round
    end

    def query(content, format, options)
      exe = inkscape_path_or_raise_error

      with_file(content, format) do |path|
        cmd = "#{external_path(exe)} #{options} #{external_path(path)}"

        call = SystemCall.new(cmd).call
        raise_query_error(call) if call.stdout.empty?

        call.stdout
      end
    end

    def with_file(content, extension)
      Dir.mktmpdir do |dir|
        path = File.join(dir, "image.#{extension}")
        File.binwrite(path, content)

        yield path
      end
    end

    def raise_query_error(call)
      raise Vectory::InkscapeQueryError,
            "Could not query with Inkscape. " \
            "Inkscape cmd: '#{call.cmd}',\n" \
            "status: '#{call.status}',\n" \
            "stdout: '#{call.stdout.strip}',\n" \
            "stderr: '#{call.stderr.strip}'."
    end
  end
end
