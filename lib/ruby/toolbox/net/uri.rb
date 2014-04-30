# Compare 2 URIs ignoring the order of request parameters
module Ruby
  module Toolbox

    class Uri

      def initialize(uri)
        @uri = uri
      end


      # Not symetric nor reflexive!
      def ==(other)
        return true if @uri.equal?(other)
        return case other
        when URI
          same_uri?(other)
        when String
          same_uri?(URI.parse(other))
        else
          false
        end

      rescue URI::InvalidURIError
        false
      end


      # Compare _@uri_ with _other_uri_, whatever the order of query params
      # @param other_uri [URI]
      #
      def same_uri?(other_uri)
        other_components_except_query = other_uri.select(*(other_uri.component - [:query]))
        components_except_query       = @uri.select(*(@uri.component - [:query]))

        (
          other_components_except_query == components_except_query &&
          query_params(other_uri)       == query_params(@uri)
        )
      end
    end
    
  end
end
