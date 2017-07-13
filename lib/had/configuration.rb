require 'pry'
require 'fileutils'

module Had
  extend self

  def configure
    yield configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def logger
    Logger.new(STDOUT)
  end

  def root
    configuration.root
  end

  class Configuration
    DEFAULT_FORMATTERS = %w(html json)

    def initialize
      Had.logger.level = Logger::INFO

      if ENV['APP_ROOT'].nil?
        raise 'APP_ROOT is not defined'
      else
        @root = ENV['APP_ROOT']
      end

      @templates_path = File.expand_path('../templates', __FILE__)
      @output_path = File.join(@root, '/doc/had')
      FileUtils.mkdir_p @output_path

      requested_formats = (ENV['HAD_FORMATTERS'].to_s).split(',')
      requested_formats.sort_by!{|fmt| [DEFAULT_FORMATTERS.index(fmt), fmt]}
      @formatters = requested_formats.empty? ? %w(html) : requested_formats

      @title = 'Hanami Api Documentation'
    end

    attr_accessor :templates_path
    attr_accessor :output_path
    attr_accessor :title
    attr_accessor :formatters
    attr_reader :root
  end
end
