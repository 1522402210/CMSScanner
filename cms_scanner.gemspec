# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cms_scanner/version'

Gem::Specification.new do |s|
  s.name                  = 'cms_scanner'
  s.version               = CMSScanner::VERSION
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.1.0'
  s.authors               = ['WPScanTeam ']
  s.email                 = ['team@wpscan.org']
  s.summary               = 'CMS Scanner Framework (experimental)'
  s.description           = 'Framework to provide an easy way to implement CMS Scanners'
  s.homepage              = 'https://github.com/wpscanteam/CMSScanner'
  s.license               = 'MIT'

  s.files                 = `git ls-files -z`.split("\x0").reject do |file|
    file =~ %r{^(?:
      spec\/.*
      |Gemfile
      |Rakefile
      |\.rspec
      |\.gitignore
      |\.rubocop.yml
      |\.travis.yml
      )$}x
  end
  s.test_files            = []
  s.executables           = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_path          = 'lib'

  s.add_dependency 'opt_parse_validator', '~> 0.0.13'
  s.add_dependency 'typhoeus', '~> 0.7'
  s.add_dependency 'nokogiri', '~> 1.6.6'
  s.add_dependency 'addressable', '~> 2.3.8'
  s.add_dependency 'activesupport', '~> 4.2'
  s.add_dependency 'public_suffix', '~> 1.5'
  s.add_dependency 'ruby-progressbar', '~> 1.7.5'

  s.add_development_dependency 'rake', '~> 10.4.2'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'rspec-its', '~> 1.2'
  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rubocop', '~> 0.32'
  s.add_development_dependency 'webmock', '~> 1.21'
  s.add_development_dependency 'simplecov', '~> 0.10'
end
