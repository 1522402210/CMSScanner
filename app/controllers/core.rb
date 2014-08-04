module CMSScanner
  module Controller
    # Core Controller
    class Core < Base
      def cli_options
        formats = Formatter.availables

        [
          OptURL.new(['-u', '--url URL'], required: true),
          OptBoolean.new(%w(-v --verbose)),
          OptFilePath.new(['-o', '--output FILE', 'Output to FILE'], writable: true, exists: false),
          OptChoice.new(['-f', '--format FORMAT',
                         "Available formats: #{formats.join(', ')}"], choices: formats)
        ] + cli_browser_options
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_browser_options
        [
          OptString.new(['--user-agent VALUE', '--ua']),
          OptInteger.new(['--cache-ttl TIME_TO_LIVE']), # TODO: the cache system
          OptCredentials.new(['--http-auth login:password']),
          OptPositiveInteger.new(['--max-threads VALUE', '-t', 'The max threads to use']),
          OptPositiveInteger.new(['--request-timeout SECONDS', 'The request timeout in seconds']),
          OptPositiveInteger.new(['--connect-timeout SECONDS',
                                  'The connection timeout in seconds'])
        ] + cli_browser_proxy_options + cli_browser_cookies_options
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_browser_proxy_options
        [
          OptProxy.new(['--proxy protocol://IP:port',
                        'Supported protocols depend on the cURL installed']),
          OptCredentials.new(['--proxy-auth login:password'])
        ]
      end

      # @return [ Array<OptParseValidator::OptBase> ]
      def cli_browser_cookies_options
        [
          OptString.new(['--cookie-string COOKIE',
                         'Cookie string to use in requests, ' \
                         'format: cookie1=value1[; cookie2=value2]']),
          OptFilePath.new(['--cookie-jar FILE-PATH', 'File to read and write cookies'],
                          writable: true,
                          exists: false,
                          default: '/tmp/cms_scanner_cookie_jar.txt')
        ]
      end

      def before_scan
        fail "The url supplied '#{target.url}' seems to be down" unless target.online?

        fail HTTPAuthRequiredError if target.http_auth?
        fail ProxyAuthRequiredError if target.proxy_auth?

        # TODO: ask if the redirection should be followed
        # if user_interaction? is allowed
        redirection = target.redirection
        fail "The url supplied redirects to #{redirection}" if redirection
      end

      def run
        @start_time   = Time.now
        @start_memory = memory_usage

        output('started', url: target.url)
        # sleep(2) # Simulate a scan
      end

      def after_scan
        @stop_time   = Time.now
        @elapsed     = @stop_time - @start_time
        @used_memory = memory_usage - @start_memory

        output('finished')
      end
    end
  end
end
