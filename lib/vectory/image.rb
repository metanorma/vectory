# frozen_string_literal: true

require "tmpdir"

module Vectory
  class Image
    class << self
      def from_path(path)
        new(File.read(path, mode: "rb"))
      end

      def from_content(content)
        new(content)
      end
    end

    attr_reader :content

    def initialize(content)
      @content = content
    end

    private

    attr_writer :content
  end
end
