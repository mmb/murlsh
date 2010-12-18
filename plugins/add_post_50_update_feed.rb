require 'uri'

require 'tinyatom'

require 'murlsh'

module Murlsh

  # Regenerate atom feed after a new url has been added.
  class AddPost50UpdateFeed < Plugin

    @hook = 'add_post'

    # Content types to add an enclosure for.
    EnclosureContentTypes = %w{
      application/pdf
      audio/mpeg
      image/gif
      image/jpeg
      image/png
      }

    def self.run(url, config)
      feed = TinyAtom::Feed.new(config['root_url'], config.fetch('page_title'),
        URI.join(config['root_url'], config['feed_file']),
        :hubs => config.fetch('pubsubhubbub_hubs', []).
          map { |x| x['subscribe_url'] } )

      latest = Murlsh::Url.all(:order => 'time DESC',
        :limit => config.fetch('num_posts_feed', 25))

      latest.each do |mu|
        options = {
          :author_name => mu.name,
          :summary => mu.title_stripped
        }

        if EnclosureContentTypes.include?(mu.content_type)
          options.merge!(
            :enclosure_type => mu.content_type,
            :enclosure_href => mu.url,
            :enclosure_title => mu.title
            )
          if mu.content_length
            options.merge! :enclosure_length => mu.content_length
          end
        end

        if mu.thumbnail_url
          begin
            # Add root url to relative urls.
            tu = URI(mu.thumbnail_url)
            abs_url = if tu.is_a?(URI::HTTP)
              tu
            else
              URI.join config['root_url'], tu
            end
            options.merge! :media_thumbnail_url => abs_url
          rescue URI::InvalidURIError
          end
        end

        Murlsh::failproof do
          if mu.via
            options.merge!(
              :via_type => 'text/html',
              :via_href => mu.via,
              :via_title => URI(mu.via).extend(Murlsh::URIDomain).domain
              )
          end
        end

        feed.add_entry mu.id, mu.title_stripped, mu.time, mu.url, options
      end

      Murlsh::openlock(config.fetch('feed_file'), 'w') do |f|
        feed.make :target => f
      end

    end

  end

end
