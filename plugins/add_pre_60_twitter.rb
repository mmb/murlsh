require 'twitter'

module Murlsh

  # Set title of twitter status urls to entire tweet.
  class AddPre60Twitter < Plugin

    @hook = 'add_pre'

    TwitterRe = %r{^https?://twitter\.com/\w+/status(?:es)?/(\d+)$}i

    def self.run(url, config)
      if not url.user_supplied_title? or not url.thumbnail_url
        if tweet_id = url.url[TwitterRe, 1]
          Murlsh.failproof do
            tweet = Twitter.status(tweet_id)

            if not url.user_supplied_title?
              url.title = "@#{tweet.user.screen_name}: #{tweet.text}"
            end

            if not url.thumbnail_url
              thumb_storage = ImgStore.new(config)

              stored_url = thumb_storage.store_url(
                tweet.user.profile_image_url) do |i|
                max_side = config.fetch('thumbnail_max_side', 90)
                i.extend(ImageList).resize_down!(max_side)
              end

              url.thumbnail_url = stored_url  if stored_url
            end
          end
        end
      end
    end

  end

end
