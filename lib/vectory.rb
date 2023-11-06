# frozen_string_literal: true

require "logger"
require_relative "vectory/version"
require_relative "vectory/utils"
require_relative "vectory/image"
require_relative "vectory/datauri"
require_relative "vectory/vector"
require_relative "vectory/eps"
require_relative "vectory/ps"
require_relative "vectory/emf"
require_relative "vectory/svg"
require_relative "vectory/svg_mapping"

module Vectory
  class Error < StandardError; end

  class ConversionError < Error; end

  class SystemCallError < Error; end

  class InkscapeNotFoundError < Error; end

  class NotImplementedError < Error; end

  class NotWrittenToDiskError < Error; end

  def self.ui
    @ui ||= Logger.new(STDOUT).tap do |logger|
      logger.level = ENV['VECTORY_LOG'] || Logger::WARN
      logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
    end
  end

  def self.root_path
    Pathname.new(File.dirname(__dir__))
  end

  def self.convert(image, format)
    image.convert(format)
  end
end
