module Vectory
  class FileMagic
    EPS_MAGIC = "\x25\x21\x50\x53\x2d\x41\x64\x6f\x62\x65"
      .force_encoding("BINARY") # "%!PS-Adobe"

    PS_MAGIC = "\x25\x21\x50\x53".force_encoding("BINARY") # "%!PS"
    EMF_MAGIC = "\x01\x00\x00\x00".force_encoding("BINARY")

    def self.detect(path)
      new(path).detect
    end

    def initialize(path)
      @path = path
    end

    def detect
      ten = File.read(@path, 10, mode: "rb")
      return :eps if ten == EPS_MAGIC

      four = ten.byteslice(0, 4)
      return :ps if four == PS_MAGIC
      return :emf if four == EMF_MAGIC

      return :svg if contain_svg_tag?
    end

    def contain_svg_tag?
      content = File.read(@path, 4096)

      return :svg if content.include?("<svg")
    end
  end
end
