# Compare 2 URIs ignoring the order of request parameters
module Ruby
  module Toolbox
    module Net

      class Uri

        def initialize(uri)
          @uri = case uri
          when String
            URI.parse(uri)
          else
            uri
          end
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


        def params_array
          @params_array ||= URI.decode_www_form(@uri.query)        
        end


        # @return [Hash] the query parameters as a Hash
        # @raise URI::InvalidURIError
        #
        def params_hash
          if RUBY_VERSION[0..1].to_f >= 2.1
            params_array.to_h  # Builtin in Ruby 2.1+
          else
            symbolize_keys( Hash[*params_array.flatten])
          end
        end


        #~~~~~~~~~~~~~~~~~
        private 

        def symbolize_keys(hash)
          Hash[ hash.map { |key, value|  [ key.to_sym, value ] }]
        end

      end
      
    end
  end
end