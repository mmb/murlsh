module Murlsh

  module Body

    # Feed body mixin.
    module FeedBody

      def initialize(config, req, feed_url, urls)
        @config, @req, @feed_url, @urls = config, req, feed_url, urls
        @updated = nil
      end

      # Yield body for Rack.
      def each; yield build; end

      # Build feed title.
      def feed_title
        result = "#{config['page_title']}"
        req['q'] ? "#{result} /#{req['q']}" : result
      end

      attr_reader :config
      attr_reader :req
      attr_reader :feed_url
      attr_reader :urls
      attr_reader :updated
    end

  end

end
