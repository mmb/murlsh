require 'rack/utils'

module Murlsh

  module Rack

    # Rack middleware to add the content encoding to the end of the ETag because
    # ETag must be different for different representations.
    class EtagAddEncoding

      def initialize(app); @app = app; end

      def call(env)
        status, headers, body = @app.call(env)

        headers = ::Rack::Utils::HeaderHash.new(headers)

        if headers['ETag']
          headers['ETag'].sub! /(")?$/, "#{headers['Content-Encoding']}\\1"
        end

        [status, headers, body]
      end

    end

  end

end
