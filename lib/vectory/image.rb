# frozen_string_literal: true

module Vectory
  class Image
    def self.from_datauri_to_content(uri)
      %r{^data:(?<imgclass>image|application)/(?<imgtype>[^;]+);(?:charset=[^;]+;)?base64,(?<imgdata>.+)$} =~ uri
      content = Base64.strict_decode64(imgdata)
      from_content(content)
    end

    def self.from_content(content)
      new(content)
    end

    attr_reader :content, :path

    def initialize(content = nil, path = nil)
      @content = content
      @path = path
    end

    def save_dataimage(uri, _relative_dir = true)
      %r{^data:(?<imgclass>image|application)/(?<imgtype>[^;]+);(?:charset=[^;]+;)?base64,(?<imgdata>.+)$} =~ uri
      imgtype = "emf" if emf?("#{imgclass}/#{imgtype}")
      imgtype = imgtype.sub(/\+[a-z0-9]+$/, "") # svg+xml
      imgtype = "png" unless /^[a-z0-9]+$/.match? imgtype
      imgtype == "postscript" and imgtype = "eps"
      Tempfile.open(["image", ".#{imgtype}"]) do |f|
        f.binmode
        f.write(Base64.strict_decode64(imgdata))
        @tempfile_cache << f # persist to the end
        f.path
      end
    end
  end
end
