# frozen_string_literal: true

require_relative "inkscape_converter"

module Vectory
  class Vector < Image
    def self.default_extension
      raise Vectory::NotImplementedError,
            "#default_extension should be implemented in a subclass."
    end

    def self.mimetype
      raise Vectory::NotImplementedError,
            "#mimetype should be implemented in a subclass."
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
  end
end
