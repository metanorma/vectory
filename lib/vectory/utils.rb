# frozen_string_literal: true

module Vectory
  class Utils
    # Extracted from https://github.com/metanorma/metanorma-utils/blob/v1.5.2/lib/utils/image.rb
    class << self
      # sources/plantuml/plantuml20200524-90467-1iqek5i.png
      # already includes localdir
      # Check whether just the local path or the other specified relative path
      # works.
      def datauri(uri, local_dir = ".")
        return uri if datauri?(uri) || url?(uri)

        options = absolute_path?(uri) ? [uri] : [uri, File.join(local_dir, uri)]
        path = options.detect do |p|
          File.exist?(p) ? p : nil
        end

        unless path
          warn "Image specified at `#{uri}` does not exist."
          return uri # Return original provided location
        end

        encode_datauri(path)
      end

      def encode_datauri(path)
        return nil unless File.exist?(path)

        type = Marcel::MimeType.for(Pathname.new(path)) ||
          'text/plain; charset="utf-8"'

        bin = File.binread(path)
        data = Base64.strict_encode64(bin)
        "data:#{type};base64,#{data}"
      rescue StandardError
        warn "Data-URI encoding of `#{path}` failed."
        nil
      end

      def datauri?(uri)
        /^data:/.match?(uri)
      end

      def url?(url)
        %r{^[A-Z]{2,}://}i.match?(url)
      end

      def absolute_path?(uri)
        %r{^/}.match?(uri) || %r{^[A-Z]:/}.match?(uri)
      end
    end
  end
end
