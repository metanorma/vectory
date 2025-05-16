# frozen_string_literal: true

module Vectory
  # The ChatGPT suggestion in the issue included 'require "ruby-units"'.
  # The css_size_to_px implementation below does not currently use the 'ruby-units' gem.
  # If 'ruby-units' is intended to be used for its parsing/conversion capabilities,
  # css_size_to_px would need to be rewritten to leverage it.
  # If you decide to use it, ensure the 'ruby-units' gem is added to your Gemfile
  # and uncomment the following line:
  # require 'ruby-units'

  # This function replaces the old image_size_percent's role for percentage calculations.
  # It's called by css_size_to_px when a percentage unit is encountered.
  # percentage_numeric_value: The numeric part of the percentage (e.g., 50.0 for "50%").
  # real_dimension: The base dimension for the percentage calculation.
  def self.image_size_percent(percentage_numeric_value, real_dimension)
    return nil if real_dimension.nil? || percentage_numeric_value.nil?

    # Calculates the dimension in pixels. The result is a float.
    (real_dimension * (percentage_numeric_value / 100.0))
  end

  # Converts CSS length string to pixels.
  # Based on the ChatGPT suggestion, with adjustments for clarity and robustness.
  # size_str: The string representing the size (e.g., "10cm", "50%", "150px", "150").
  # real_dimension_for_percentage: Used as the base when size_str is a percentage.
  # dpi: Dots per inch for physical unit conversions (in, cm, mm, pt, pc).
  def self.css_size_to_px(size_str, real_dimension_for_percentage, dpi: 96)
    return nil unless size_str.is_a?(String)

    cleaned_size_str = size_str.strip.downcase

    # Handle keywords like "auto" which don't resolve to a numeric pixel value.
    # The original code would convert "auto" to 0 via "auto".to_i. Returning nil is more appropriate.
    return nil if cleaned_size_str == "auto"

    # Handle plain numbers (e.g., "150") as pixels.
    if cleaned_size_str.match?(/^\d+(\.\d+)?$/)
      return cleaned_size_str.to_f.to_i
    end

    # Match numeric value and unit (e.g., "10.5cm", "50%", "-5px").
    match = cleaned_size_str.match(/^([-+]?[0-9]*\.?[0-9]+)([a-z%]+)$/)
    unless match
      # Not a plain number and not in "valueUnit" format (e.g., malformed, or unsupported like "10em").
      return nil
    end

    value = match[1].to_f
    unit = match[2]
    px_value = nil # This will store the calculated pixel value as a float.

    case unit
    when 'px'
      px_value = value
    when 'in'
      px_value = value * dpi
    when 'cm'
      px_value = value * dpi / 2.54
    when 'mm'
      px_value = value * dpi / 25.4 # Ensure this divisor is 25.4, not 25.6 or other value
    when 'pt' # 1 point = 1/72 inch
      px_value = value * dpi / 72.0
    when 'pc' # 1 pica = 12 points
      px_value = value * 12.0 * dpi / 72.0 # or value * dpi / 6.0
    when '%'
      # 'value' is the numeric part (e.g., 50.0 for "50%").
      # 'real_dimension_for_percentage' is the base size.
      px_value = image_size_percent(value, real_dimension_for_percentage)
    else
      return nil # Unknown unit
    end

    return nil if px_value.nil?

    # For 'px' and '%' units, truncate to match "integer conversion" expectation.
    # For physical units, round to handle floating point inaccuracies correctly.
    if ['px', '%'].include?(unit)
      return px_value.to_i
    else
      return px_value.round
    end
  end

  # Updated image_size_interpret function.
  # img: Hash containing "width" and/or "height" strings (e.g., {"width" => "16.36cm"}).
  # realsize: Array [parent_width_in_px, parent_height_in_px] for percentage calculations.
  # dpi: Dots per inch, crucial for converting physical units to pixels. Default is 96,
  #      but should ideally be set based on the output context (HTML, PDF, Word).
  def self.image_size_interpret(img, realsize, dpi: 96)
    # Ensure realsize components are properly accessed, defaulting to nil if not available.
    parent_w_px = realsize.is_a?(Array) && realsize.length > 0 ? realsize[0] : nil
    parent_h_px = realsize.is_a?(Array) && realsize.length > 1 ? realsize[1] : nil

    # Process width, if specified in img hash
    w_px = img["width"] ? css_size_to_px(img["width"], parent_w_px, dpi: dpi) : nil
    
    # Process height, if specified in img hash
    h_px = img["height"] ? css_size_to_px(img["height"], parent_h_px, dpi: dpi) : nil

    [w_px, h_px]
  end

  # == Important Note on the old `image_size_percent` function ==
  # The original `image_size_percent` function, as described in the issue:
  #
  #   def image_size_percent(value, real)
  #     /%$/.match?(value) && !real.nil? and
  #       value = real * (value.sub(/%$/, "").to_f / 100)
  #     value.to_i
  #   end
  #
  # This old function had behavior that led to the reported bug:
  # 1. It attempted to parse percentage strings but also converted other non-percentage
  #    strings to integers using `to_i` (e.g., "13.5cm".to_i resulted in 13).
  # 2. Strings like "auto" would become 0 due to "auto".to_i.
  #
  # This old function should be REMOVED from codebase.
  # Its responsibilities are now correctly handled by:
  #   - The `css_size_to_px` function for robust parsing of various units and strings.
  #   - The new `image_size_percent` (defined above in this file) which now serves as a
  #     focused helper for percentage math, taking numeric inputs.
end