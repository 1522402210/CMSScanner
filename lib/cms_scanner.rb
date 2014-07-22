# Gems
require 'opt_parse_validator'
require 'typhoeus'
require 'nokogiri'
require 'active_support/inflector'
require 'addressable/uri'
# Standard Libs
require 'pathname'
require 'erb'
# Custom Libs
require 'helper'
require 'cms_scanner/errors/auth_errors'
require 'cms_scanner/target'
require 'cms_scanner/browser'
require 'cms_scanner/version'
require 'cms_scanner/controller'
require 'cms_scanner/controllers'
require 'cms_scanner/formatter'

# Module
module CMSScanner
  APP_DIR = Pathname.new(__FILE__).dirname.join('..', 'app').expand_path

  # Scan
  class Scan
    def initialize
      controllers << Controller::Core.new
      yield self if block_given?
    end

    # @return [ Controllers ]
    def controllers
      @controllers ||= Controllers.new
    end

    def run
      controllers.run(custom_views)
    rescue => e
      formatter.output('@scan_aborted',
                       reason: e.message,
                       trace: e.backtrace,
                       verbose: controllers.first.parsed_options[:verbose])
    ensure
      formatter.beautify
    end

    # Used for convenience
    # @See Formatter
    def formatter
      controllers.first.formatter
    end

    # @return [ Array<String> ] A list of directories path where to look for views
    def custom_views
      @custom_views ||= []
    end
  end
end

require "#{CMSScanner::APP_DIR}/app"
