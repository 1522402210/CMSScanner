module CMSScanner
  module Finder
    # Dummy Test Finder
    class DummyFinder < Base
      def passive(_opts = {})
        'test'
      end

      def aggressive(_opts = {})
        { result: 'test', confidence: 100, method: 'override' }
      end
    end

    # No aggressive result finder
    class NoAggressiveResult < Base
      def passive(_opts = {})
        { result: 'spotted', confidence: 10 }
      end
    end
  end
end
