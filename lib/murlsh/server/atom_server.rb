require 'uri'

module Murlsh

  module Server

    # Serve Atom feed.
    class AtomServer < BaseServer

      # Respond to a GET request for Atom feed.
      def get(req)
        page = 1
        per_page = config.fetch('num_posts_feed', 25)

        result_set = UrlResultSet.new(req['q'], page, per_page)

        feed_url = URI.join(config.fetch('root_url'), config.fetch('feed_file'))
        body = AtomBody.new(config, req, feed_url, result_set.results)

        resp = build_response(body, 200,
          'Content-Type' => 'application/atom+xml')
        if u = body.updated
          resp['Last-Modified'] = u.httpdate
        end
        resp
      end

    end

  end

end
