require 'time'

require 'rack'
require 'rack/utils'

module Murlsh

  module Rack

    # Rack middleware to set a far future expires header for urls that match
    # patterns.
    class FarFutureExpires

      def initialize(app, options={})
        @app = app
        @patterns = options[:patterns] ? [*options[:patterns]] : []
        # rfc2616 HTTP/1.1 servers SHOULD NOT send Expires dates more than one
        # year in the future.
        @future = options[:future] || (Time.now + 31536000).httpdate
      end

      def call(env)
        status, headers, body = @app.call(env)

        req = ::Rack::Request.new(env)

        headers = ::Rack::Utils::HeaderHash.new(headers)

        @patterns.each do |pattern|
          if pattern.match(req.path)
            headers['Expires'] = @future
            break
          end
        end

        [status, headers, body]
      end

    end

  end

end
