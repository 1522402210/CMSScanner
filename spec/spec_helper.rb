$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
require 'rspec/its'
require 'webmock/rspec'
require 'active_support/time'

if ENV['TRAVIS']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_filter '/spec/'
  add_filter 'helper'
end

# See http://betterspecs.org/
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def count_files_in_dir(absolute_dir_path, files_pattern = '*')
  Dir.glob(File.join(absolute_dir_path, files_pattern)).count
end

# Parse a file containing raw headers and return the associated Hash
# @return [ Hash ]
def parse_headers_file(filepath)
  Typhoeus::Response::Header.new(File.read(filepath))
end

require 'cms_scanner'
require 'shared_examples'

SPECS          = Pathname.new(__FILE__).dirname.to_s
CACHE          = File.join(SPECS, 'cache')
FIXTURES       = File.join(SPECS, 'fixtures')
FIXTURES_VIEWS = File.join(FIXTURES, 'views')
APP_VIEWS      = File.join(CMSScanner::APP_DIR, 'views')
