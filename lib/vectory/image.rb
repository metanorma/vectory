# frozen_string_literal: true

require "tmpdir"

module Vectory
  class Image
    def self.from_datauri_to_content(uri)
      %r{^data:(?<_imgclass>image|application)/(?<_imgtype>[^;]+);(?:charset=[^;]+;)?base64,(?<imgdata>.+)$} =~ uri
      content = Base64.strict_decode64(imgdata)
      from_content(content)
    end

    def self.from_path(path)
      content = File.read(path, mode: "rb")
      new(content, path)
    end

    def self.from_content(content)
      new(content)
    end

    def self.default_extension
      raise Vectory::NotImplementedError,
            "#default_extension should be implemented in a subclass."
    end

    attr_reader :content, :path

    def initialize(content = nil, path = nil)
      @content = content
      @path = path
    end

    def write(path)
      File.binwrite(path, @content)
      @path = File.expand_path(path)

      self
    end

    def convert_with_inkscape(inkscape_options, target_class)
      with_file(self.class.default_extension) do |input_path|
        output_extension = target_class.default_extension
        output_path = InkscapeConverter.instance.convert(input_path,
                                                         output_extension,
                                                         inkscape_options)

        target_class.from_path(output_path)
      end
    end

    def with_file(input_extension)
      Dir.mktmpdir do |dir|
        input_path = File.join(dir, "image.#{input_extension}")
        File.binwrite(input_path, @content)

        yield input_path
      end
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
