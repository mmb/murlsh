require 'rss/maker'

module Murlsh

  module Body

    # Rss feed builder.
    class RssBody
      include FeedBody

      # Rss feed builder.
      def build
        if defined?(@body)
          @body
        else
          feed = RSS::Maker.make('2.0') do |f|
            f.channel.title = f.channel.description = feed_title
            f.channel.link = feed_url

            f.items.do_sort = true

            urls.each do |mu|
              Plugin.hooks('url_display_pre') { |p| p.run mu, req, config }

              i = f.items.new_item
              i.title = mu.title_stripped
              i.link = mu.url
              i.date = mu.time

              mu.enclosures.first(1).each do |e|
                i.enclosure.url = e.enclosure_url
                i.enclosure.type = e.content_type
                i.enclosure.length = e.content_length
              end

            end
          end

          @body = feed
        end
      end

    end

  end

end
