# frozen_string_literal: true

require "base64"
require "marcel"
require "tempfile"

module Vectory
  class Utils
    class << self
      # Extracted from https://github.com/metanorma/metanorma-utils/blob/v1.5.2/lib/utils/image.rb
      #
      # sources/plantuml/plantuml20200524-90467-1iqek5i.png
      # already includes localdir
      # Check whether just the local path or the other specified relative path
      # works.
      def datauri(uri, local_dir = ".")
        (datauri?(uri) || url?(uri)) and return uri

        path = path_which_exist(uri, local_dir)
        path and return encode_datauri(path)

        Vectory.ui.warn "Image specified at `#{uri}` does not exist."
        uri # Return original provided location
      end

      def path_which_exist(uri, local_dir)
        options = absolute_path?(uri) ? [uri] : [uri, File.join(local_dir, uri)]
        options.detect do |p|
          File.file?(p)
        end
      end

      def encode_datauri(path)
        return nil unless File.exist?(path)

        type = Marcel::MimeType.for(Pathname.new(path)) ||
          'text/plain; charset="utf-8"'

        bin = File.binread(path)
        data = Base64.strict_encode64(bin)
        "data:#{type};base64,#{data}"
        # rescue StandardError
        #   warn "Data-URI encoding of `#{path}` failed."
        #   nil
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

      def svgmap_rewrite0_path(src, localdirectory)
        if /^data:/.match?(src)
          save_dataimage(src)
        else
          File.file?(src) ? src : localdirectory + src
        end
      end

      def save_dataimage(uri)
        %r{^data:(?:image|application)/(?<imgtype>[^;]+);(?:charset=[^;]+;)?base64,(?<imgdata>.+)$} =~ uri # rubocop:disable Layout/LineLength
        imgtype.sub!(/\+[a-z0-9]+$/, "") # svg+xml
        imgtype = "png" unless /^[a-z0-9]+$/.match? imgtype
        Tempfile.open(["image", ".#{imgtype}"]) do |f|
          f.binmode
          f.write(Base64.strict_decode64(imgdata))
          f.path
        end
      end

      # FIXME: This method should ONLY return 1 type, remove Array wrapper
      def datauri2mime(uri)
        output = decode_datauri(uri)
        return nil unless output && output[:type_detected]

        [output[:type_detected]]
      end

      def decode_datauri(uri)
        %r{^data:(?<mimetype>[^;]+);base64,(?<mimedata>.+)$} =~ uri
        return nil unless mimetype && mimedata

        data = Base64.strict_decode64(mimedata)
        {
          type_declared: mimetype,
          type_detected: Marcel::MimeType.for(data, declared_type: mimetype),
          data: data,
        }
      end
    end
  end
end
