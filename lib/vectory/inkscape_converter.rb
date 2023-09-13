# frozen_string_literal: true

require 'singleton'

module Vectory
  class InkscapeConverter
    include Singleton

    def convert(uri, _file, option)
      exe = installed? or raise "Inkscape missing in PATH, unable" \
                                         "to convert image #{uri}. Aborting."
      uri = external_path uri
      exe = external_path exe
      cmd = %(#{exe} #{option} #{uri})

      system(cmd, exception: true)

      # and return Vectory::Utils::datauri(file)
      # raise %(Fail on #{exe} #{option} #{uri})
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

    private

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
