require 'rack'

require 'murlsh'

module Murlsh

  # Redirect to a random url from the database.
  class RandomServer

    def initialize(config); @config = config; end

    # Redirect to a random url from the database optionally matching a query.
    #
    # Redirect to root url if no urls match.
    def get(req)
      if choice = random_url(Murlsh::SearchConditions.new(req['q']).conditions)
        url = choice.url
      else
        url = config.fetch('root_url')
      end

      resp = Rack::Response.new "<a href=\"#{url}\">#{url}</a>"
      resp.redirect(url)

      resp
    end

    # Select a random url from the database optionally matching a query.
    #
    # Return nil if no urls match.
    def random_url(conditions=[])
      count = Murlsh::Url.count(:conditions => conditions)
      if count > 0
        Murlsh::Url.first(:conditions => conditions, :offset => rand(count))
      end
    end

    attr_reader :config
  end

end
