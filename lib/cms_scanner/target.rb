require 'cms_scanner/web_site'
require 'cms_scanner/target/platform'
require 'cms_scanner/target/server'

module CMSScanner
  # Target to Scan
  class Target < WebSite
    include Server::Generic

    # @param [ String ] url
    # @param [ Hash ] opts
    # @option opts [ Array<PublicSuffix::Domain, String> ] :scope
    def initialize(url, opts = {})
      super(url, opts)

      scope << domain
      [*opts[:scope]].each { |s| scope << s }
    end

    def domain
      @domain ||= PublicSuffix.parse(uri.host)
    end

    # @return [ Array<PublicSuffix::Domain, String> ]
    def scope
      @scope ||= []
    end

    # // are handled by Addressable::URI, but worngly :/
    # e.g: Addressable::URI.parse('//file').host => file
    #
    # Idea: parse the // with PublicSuffix to see if a valid
    #       domain is used
    #
    # @param [ String ] url
    #
    # @return [ Boolean ] true if the url given is in scope
    def in_scope?(url)
      return true if url[0, 1] == '/' && url[1, 1] != '/'

      url_domain = PublicSuffix.parse(Addressable::URI.parse(url).host)

      scope.each { |pattern| return true if url_domain.match(pattern) }

      false
    rescue
      false
    end

    # TODO: add a force option to re-call the #find rather than return the @interesting_files ?
    #
    # @param [ Hash ] opts
    #
    # @return [ Findings ]
    def interesting_files(opts = {})
      @interesting_files ||= NS::Finders::InterestingFiles.find(self, opts)
    end
  end
end
