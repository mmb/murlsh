require 'uri'

module Murlsh

  # Serve m3u file of audio urls.
  class M3uServer < Server

    AudioContentTypes = %w{
      application/ogg
      audio/mpeg
      audio/ogg
      }

    # Respond to a GET request for m3u file.
    def get(req)
      page = 1
      per_page = config.fetch('num_posts_feed', 25)

      result_set = UrlResultSet.new(req['q'], page, per_page,
        :content_type => AudioContentTypes)

      feed_url = URI.join(config.fetch('root_url'), 'm3u.m3u')
      body = M3uBody.new(config, req, feed_url, result_set.results)

      resp = build_response(body, 200, 'Content-Type' => 'audio/x-mpegurl')
      if u = body.updated
        resp['Last-Modified'] = u.httpdate
      end
      resp
    end

  end

end
