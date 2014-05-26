# Compare 2 URIs ignoring the order of request parameters
module Ruby
  module Toolbox
    module Net
      
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


        # TODO: Doc + Test
        def params_hash
          uri = URI.parse(@uri)
          params_array = URI.decode_www_form(uri.query)
  #TODO:        return params_array.to_h if RUBY_VERSION  <= 2.1
          if params_array.nil? 
            {} 
          else
            Hash[*params_array.flatten]
          end
        end
      end
      
    end
  end
end