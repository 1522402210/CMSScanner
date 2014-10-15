module CMSScanner
  class Target < WebSite
    module Server
      # Some Apche specific implementation
      module Generic
        # @param [ String ] path
        # @param [ Hash ] params The request params
        #
        # @return [ Symbol ] The detected remote server (:Apache, :IIS)
        def server(path = nil, params = {})
          headers = headers(path, params)

          return nil unless headers

          case headers[:server]
          when /\Aapache/i
            :Apache
          when /\AMicrosoft-IIS/i
            :IIS
          end
        end

        # @param [ String ] path
        # @param [ Hash ] params The request params
        #
        # @return [ Hash ] The headers
        def headers(path = nil, params = {})
          # The HEAD method might be rejected by some servers ... maybe switch to GET ?
          NS::Browser.head(url(path), params).headers
        end
      end
    end
  end
end
