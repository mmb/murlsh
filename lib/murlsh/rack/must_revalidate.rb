require 'rack'
require 'rack/utils'

module Murlsh

  module Rack

    # Rack middleware to force caches to always revalidate for urls that match
    # patterns.
    class MustRevalidate

      def initialize(app, options={})
        @app = app
        @patterns = Array(options[:patterns])
      end

      def call(env)
        status, headers, body = @app.call(env)

        req = ::Rack::Request.new(env)

        headers = ::Rack::Utils::HeaderHash.new(headers)

        @patterns.each do |pattern|
          if pattern.match(req.path)
            headers['Cache-Control'] = 'must-revalidate, max-age=0'
            break
          end
        end

        [status, headers, body]
      end

    end

  end

end
