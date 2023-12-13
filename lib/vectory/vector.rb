# frozen_string_literal: true

require "tempfile"
require_relative "inkscape_converter"

module Vectory
  class Vector < Image
    def self.from_path(path)
      content = File.read(path, mode: "rb")
      new(content, path)
    end

    def self.from_datauri(uri)
      Datauri.new(uri).to_vector
    end

    def self.default_extension
      raise Vectory::NotImplementedError,
            "#default_extension should be implemented in a subclass."
    end

    def self.mimetype
      raise Vectory::NotImplementedError,
            "#mimetype should be implemented in a subclass."
    end

    attr_reader :initial_path

    def initialize(content = nil, initial_path = nil)
      super(content)

      @initial_path = initial_path
    end

    def mime
      self.class.mimetype
    end

    def size
      content.bytesize
    end

    def file_size
      raise(NotWrittenToDiskError) unless @path

      File.size(@path)
    end

    def height
      InkscapeConverter.instance.height(content, self.class.default_extension)
    end

    def width
      InkscapeConverter.instance.width(content, self.class.default_extension)
    end

    def to_uri
      Datauri.from_vector(self)
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

    def write(path = nil)
      target_path = path || @path || tmp_path
      File.binwrite(target_path, content)
      @path = File.expand_path(target_path)

      self
    end

    def path
      @path || raise(NotWrittenToDiskError)
    end

    private

    def with_file(input_extension)
      Dir.mktmpdir do |dir|
        input_path = File.join(dir, "image.#{input_extension}")
        File.binwrite(input_path, content)

        yield input_path
      end
    end

    def tmp_path
      dir = Dir.mktmpdir
      filename = "image.#{self.class.default_extension}"
      File.join(dir, filename)
    end
  end
end
