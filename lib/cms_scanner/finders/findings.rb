module CMSScanner
  module Finders
    # Findings container
    class Findings < Array
      # Override to include the confirmed_by logic
      #
      # @param [ Finding ] finding
      def <<(finding)
        each do |found|
          next unless found == finding

          found.confirmed_by << finding
          found.confidence += finding.confidence

          return self
        end

        super(finding)
      end
    end
  end
end
