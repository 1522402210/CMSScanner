module CMSScanner
  module Finders
    # Unique Finder
    module UniqueFinder
      include IndependentFinder # Doesn't work :/

      # @return [ Array ]
      def finders
        @finders ||= NS::Finders::UniqueFinders.new
      end
    end
  end
end
