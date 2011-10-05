require 'uri'

module Murlsh

  # Notify PubSubHubbub hubs that feed has been updated.
  class AddPost60NotifyHubs < Plugin

    @hook = 'add_post'

    def self.run(url, config)
      hubs = config.fetch('pubsubhubbub_hubs', [])

      unless hubs.empty?
        require 'push-notify'

        feed_url = URI.join(config.fetch('root_url'), config.fetch('feed_file'))
        begin
          PushNotify::Content.new(feed_url).tell(
            *hubs.map { |h| h.fetch('publish_url') })
        rescue Exception
        end
      end
    end

  end

end
