module CMSScanner
  # Options available in the Browser
  class Browser
    OPTIONS = %i[
      cache_ttl
      cookie_jar
      cookie_string
      connect_timeout
      headers
      http_auth
      max_threads
      proxy
      proxy_auth
      random_user_agent
      request_timeout
      throttle
      user_agent
      user_agents_list
      vhost
    ].freeze

    attr_accessor(*OPTIONS)

    # @return [ String ]
    def default_user_agent
      "#{NS} v#{NS::VERSION}"
    end

    def hydra
      @hydra ||= Typhoeus::Hydra.new(max_concurrency: max_threads || 1)
    end

    # @param [ Hash ] options
    def load_options(options = {})
      OPTIONS.each do |sym|
        send("#{sym}=", options[sym]) if options.key?(sym)
      end
    end

    # Set the threads attribute and update
    # the max_concurrency of Typhoeus::Hydra
    #
    # If the throttle attribute is > 0, max_threads will be forced to 1
    #
    # @param [ Integer ] number
    def max_threads=(number)
      @max_threads = number.to_i.positive? && throttle.zero? ? number.to_i : 1

      hydra.max_concurrency = @max_threads
    end

    # @return [ String ] The user agent
    def user_agent
      @user_agent ||= random_user_agent ? user_agents.sample : default_user_agent
    end

    # @return [ Array<String> ]
    def user_agents
      return @user_agents if @user_agents

      @user_agents = []

      File.open(user_agents_list).each do |line|
        next if line == "\n" || line[0, 1] == '#'
        @user_agents << line.chomp
      end

      @user_agents
    end

    # @return [ String ] The path to the user agents list
    def user_agents_list
      @user_agents_list ||= File.join(APP_DIR, 'user_agents.txt')
    end

    # @param [ value ] The throttle time in milliseconds
    #
    # if value > 0, the max_threads will be set to 1
    def throttle=(value)
      @throttle = value.to_i.abs / 1000.0

      self.max_threads = 1 if @throttle.positive?
    end

    def trottle!
      sleep(throttle) if throttle.positive?
    end
  end
end
