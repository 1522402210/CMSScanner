require 'cms_scanner/web_site'
require 'cms_scanner/target/platform'
require 'cms_scanner/target/server'

module CMSScanner
  # Target to Scan
  class Target < WebSite
    include Server::Generic
    # @note Subdomains are considered out of scope (maybe consider them in ?)
    #       Also, // are handled by Addressable::URI, but worngly :/
    #       e.g: Addressable::URI.parse('//file').host => file
    #
    # @param [ String ] url
    #
    # @return [ Boolean ] true if the url given belongs to the target
    def in_scope?(url)
      return true if url[0, 1] == '/' && url[1, 1] != '/'

      Addressable::URI.parse(url).host == uri.host
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
