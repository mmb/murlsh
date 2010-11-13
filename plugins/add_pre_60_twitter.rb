require 'twitter'

require 'murlsh'

module Murlsh

  # Set title to entire tweet and set thumbnail url.
  class AddPre60Twitter < Plugin

    @hook = 'add_pre'

    TwitterRe = %r{^https?://twitter\.com/\w+/status(?:es)?/(\d+)$}i

    def self.run(url, config)
      if tweet_id = url.url[TwitterRe, 1]
        tweet = Twitter.status(tweet_id)

        url.title = "@#{tweet.user.screen_name}: #{tweet.text}"
      end
    end

  end

end
