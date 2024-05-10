require "image_size"

module Vectory
  class ImageResize
    BORDER_WIDTH = 2

    def call(img, path, maxheight, maxwidth)
      s, realsize = get_image_size(img, path)
      img.name == "svg" && !img["viewBox"] && s[0] && s[1] and
        img["viewBox"] = viewbox(s)
      s, skip = image_dont_resize(s, realsize)
      skip and return s
      s = image_size_fillin(s, realsize)
      image_shrink(s, maxheight, maxwidth)
    end

    def get_image_size(img, path)
      detected = detect_size(path)
      realsize = detected if detected
      s = image_size_interpret(img, realsize || [nil, nil])
      image_size_zeroes_complete(s, realsize)
    end

    private

    def detect_size(path)
      size = ImageSize.path(path).size
      return unless size
      return if size.all? { |x| x.nil? || x.zero? }

      size
    end

    def viewbox(dimensions)
      width = dimensions[0] + BORDER_WIDTH
      height = dimensions[1] + BORDER_WIDTH

      "0 0 #{width} #{height}"
    end

    def image_dont_resize(dim, realsize)
      dim.nil? and return [[nil, nil], true]
      realsize.nil? and return [dim, true]
      dim[0] == nil && dim[1] == nil and return [dim, true]
      [dim, false]
    end

    def image_size_fillin(dim, realsize)
      dim[1] = fill_size(dim[1], dim[0], realsize[1], realsize[0])
      dim[0] = fill_size(dim[0], dim[1], realsize[0], realsize[1])

      dim
    end

    def fill_size(current, another, real_current, real_another)
      return current unless current.zero? && !another.zero?

      another * real_current / real_another
    end

    def image_shrink(dim, maxheight, maxwidth)
      dim[1] > maxheight and
        dim = [(dim[0] * maxheight / dim[1]).ceil, maxheight]
      dim[0] > maxwidth and
        dim = [maxwidth, (dim[1] * maxwidth / dim[0]).ceil]
      dim
    end

    def image_size_interpret(img, realsize)
      w = image_size_percent(img["width"], realsize[0])
      h = image_size_percent(img["height"], realsize[1])
      [w, h]
    end

    def image_size_percent(value, real)
      /%$/.match?(value) && !real.nil? and
        value = real * (value.sub(/%$/, "").to_f / 100)
      value.to_i
    end

    def image_size_zeroes_complete(dim, realsize)
      if dim[0].zero? && dim[1].zero?
        dim = realsize
      end
      [dim, realsize]
    end
  end
end
