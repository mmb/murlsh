require 'uri'

module Murlsh

  # Show a via link for the url.
  class UrlDisplayAdd60Via < Plugin

    @hook = 'url_display_add'

    HttpRe = %r{^https?://}i
    HackerNewsRe = %r{^news\.ycombinator\.com}i
    RedditRe = %r{^www\.reddit\.com/r/([a-z\d]+?)/}i
    DeliciousRe = %r{^(?:www\.)?delicious\.com/(\w+)}i
    TwitterRe = %r{^twitter\.com/(\w+)}i
    TumblrRe = %r{^([a-z\d][a-z\d-]{0,61}[a-z\d])\.tumblr\.com/}i
    PinboardRe = %r{^pinboard\.in/(popular|[tu]:[^/]+(?:/t:[^/]+)?)/?$}i

    # Show a via link for the url.
    def self.run(markup, url, config)
      if url.via
        if via_uri = Murlsh.failproof { URI(url.via) }
          via_uri_s = via_uri.to_s
          search = via_uri_s.gsub(HttpRe, '')

          display_via = case
            when search.match(HackerNewsRe); 'hacker news'
            when m = search.match(RedditRe); "#{m[1]}.reddit"
            when m = search.match(DeliciousRe); "delicious/#{m[1]}"
            when m = search.match(TwitterRe); "twitter/#{m[1]}"
            when m = search.match(TumblrRe); "#{m[1]}.tumblr"
            when m = search.match(PinboardRe); "pinboard/#{m[1]}"
            else via_uri.extend(URIDomain).domain || via_uri_s
          end

          markup.span(:class => 'via') do
            markup.text! ' via '
            markup.a display_via, :href => via_uri_s
          end
        end
      end
    end

  end

end

