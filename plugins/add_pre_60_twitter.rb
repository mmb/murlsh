require 'twitter'

module Murlsh

  # Set title of twitter status urls to entire tweet.
  class AddPre60Twitter < Plugin

    @hook = 'add_pre'

    TwitterRe = %r{^https?://twitter\.com/\w+/status(?:es)?/(\d+)$}i

    def self.run(url, config)
      if not url.user_supplied_title? and tweet_id = url.url[TwitterRe, 1]
        tweet = Twitter.status(tweet_id)

        url.title = "@#{tweet.user.screen_name}: #{tweet.text}"
      end
    end

  end

end
