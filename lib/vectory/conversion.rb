module Vectory
  class Conversion
    def self.convert_to_svg(file, output = nil)
      opts = []
      opts << "--export-type=svg"
      opts << "--export-plain-svg"
      opts << "--export-filename #{output}" if output
      # FIXME: handle path issues on Windows
      # cmd = "C:\\Program` Files\\Inkscape\\bin\\inkscapecom #{opts.join(" ")} #{file}"
      cmd = "inkscape #{opts.join(" ")} #{file}"
      Vectory.ui.debug("Cmd: #{cmd}")
      system(cmd, exception: true)
    end
  end
end
