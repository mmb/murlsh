require 'uri'

module Murlsh

  # Get Gravatar url from a url.
  class Avatar50Gravatar < Plugin

    @hook = 'avatar'

    def self.run(avatar_url, url, config)
      if url.email and not url.email.empty? and
        (gravatar_size = config.fetch('gravatar_size', 0)) > 0
        query = { :s => gravatar_size }
        URI.join('http://www.gravatar.com/avatar/', url.email,
          Murlsh.build_query(query))
      end
    end

  end

end
