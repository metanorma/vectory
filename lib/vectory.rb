# frozen_string_literal: true

require "logger"
require_relative "vectory/version"
require_relative "vectory/conversion"
require_relative "vectory/utils"
require_relative "vectory/image"
require_relative "vectory/eps"
require_relative "vectory/emf"
require_relative "vectory/svg"

module Vectory
  class Error < StandardError; end

  def self.ui
    @ui ||= Logger.new(STDOUT).tap do |logger|
      logger.level = ENV['VECTORY_LOG'] || Logger::WARN
    end
  end

  def self.root_path
    Pathname.new(File.dirname(__dir__))
  end

  def self.convert_to_svg(file, output = nil)
    Vectory::Conversion.convert_to_svg(file, output)
  end

  def self.convert(image, format)
    image.convert(format)
  end
end
