module CMSScanner
  module Controller
    # Core Controller
    class Core < Base
      def cli_options
        [
          OptURL.new(['-u', '--url URL'], required: true),
          OptBoolean.new(%w(-v --verbose)),
          OptFilePath.new(['-o', '--output FILE', 'Output to FILE'], writable: true, exists: false),
          OptString.new(['-f', '--format FORMAT']), # Should be OptChoice
        ] + cli_browser_options
      end

      # @return [ Array ]
      def cli_browser_options
        [
          OptInteger.new(['--cache-ttl TIME_TO_LIVE']), # TODO: the cache system
          OptPositiveInteger.new(['--connect-timeout SECONDS',
                                  'The connection timeout in seconds']),
          OptCredentials.new(['--http-auth login:password']),
          OptPositiveInteger.new(['--threads VALUE', '-t', 'The max threads to use']),
          OptProxy.new(['--proxy protocol://IP:port',
                        'Supported protocols depend on the cURL installed']),
          OptCredentials.new(['--proxy-auth login:password']),
          OptPositiveInteger.new(['--request-timeout SECONDS', 'The request timeout in seconds']),
          OptString.new(['--user-agent VALUE', '--ua'])
        ]
      end

      def before_scan
        fail "The url supplied '#{target.url}' seems to be down" unless target.online?

        if target.basic_auth? && !parsed_options[:basic_auth]
          fail 'Basic authentication is required, please provide it with --basic-auth'
        end

        # TODO: ask if the redirection should be followed
        # if user_interaction? is allowed
        if (redirection = target.redirection)
          fail "The url supplied redirects to #{redirection}"
        end
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
