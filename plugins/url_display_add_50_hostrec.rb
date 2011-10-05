require 'uri'

module Murlsh

  # Show the domain of the url.
  class UrlDisplayAdd50HostRec < Plugin

    @hook = 'url_display_add'

    SkipDomains = %w{
      wikipedia.org
      flickr.com
      github.com
      twitpic.com
      twitter.com
      vimeo.com
      youtube.com
      }

    # Show the domain of the url.
    def self.run(markup, url, config)
      domain = Murlsh.failproof { URI(url.url).extend(URIDomain).domain }
      if domain
        # show domain if not already contained in title and not on skip list
        unless (url.title and url.title.downcase.index(domain)) or
          SkipDomains.include?(domain)
          markup.span " [#{domain}]", :class => 'host'
        end
      end
    end

  end

end
