require 'uri'

require 'tinyatom'

module Murlsh

  # Atom feed builder.
  class AtomBody
    include FeedBody

    # Atom feed builder.
    def build
      if defined?(@body)
        @body
      else
        feed = TinyAtom::Feed.new(config.fetch('root_url'), feed_title,
          feed_url, :hubs => config.fetch('pubsubhubbub_hubs', []).
          map { |x| x['subscribe_url'] })

        urls.each do |mu|
          Plugin.hooks('url_display_pre') do |p|
            p.run mu, req, config
          end

          options = {
            :author_name => mu.name,
            :summary => mu.title_stripped
          }

          options[:enclosures] = []
          mu.enclosures.each do |e|
            new_e = {
              :enclosure_href => e.enclosure_url,
              :enclosure_title => e.title_stripped,
              :enclosure_type => e.content_type
            }

            new_e[:enclosure_length] = e.content_length  if e.content_length

            options[:enclosures] << new_e
          end

          if mu.thumbnail_url
            begin
              # Add root url to relative urls.
              tu = URI(mu.thumbnail_url)
              abs_url = if tu.is_a?(URI::HTTP)
                tu
              else
                URI.join config.fetch('root_url'), tu
              end
              options.merge! :media_thumbnail_url => abs_url
            rescue URI::InvalidURIError
            end
          end

          Murlsh.failproof do
            if mu.via
              options.merge!(
                :via_type => 'text/html',
                :via_href => mu.via,
                :via_title => URI(mu.via).extend(URIDomain).domain
                )
            end
          end

          feed.add_entry mu.id, mu.title_stripped, mu.time, mu.url, options
        end

        @updated = feed.updated
        @body = feed.make
      end

    end

  end

end
