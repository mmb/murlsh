module Murlsh

  # Serve most recent urls in json.
  class JsonServer < Server

    # Respond to a GET request with json of recent urls.
    def get(req)
      page = 1
      per_page = config.fetch('num_posts_feed', 25)

      result_set = UrlResultSet.new(req['q'], page, per_page)

      body = JsonBody.new(config, req, result_set)

      build_response body, 200, 'Content-Type' => 'application/json'
    end

  end

end
