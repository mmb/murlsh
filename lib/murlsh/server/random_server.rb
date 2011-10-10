module Murlsh

  module Server

    # Redirect to a random url from the database.
    class RandomServer < BaseServer

      # Redirect to a random url from the database optionally matching a query.
      #
      # Redirect to root url if no urls match.
      def get(req)
        all_results = UrlResultSet.new(req['q'], 1, 1)

        url = if all_results.total_entries > 0
          UrlResultSet.new(req['q'],
            rand(all_results.total_entries) + 1, 1).results[0].url
        else
          config.fetch('root_url')
        end

        resp = build_response("<a href=\"#{url}\">#{url}</a>")
        resp.redirect(url)

        resp
      end

    end

  end

end
