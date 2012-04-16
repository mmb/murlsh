module Murlsh

  # Create video enclosures for YouTube urls.
  class AddPre55EnclosureYoutube < Plugin

    @hook = 'add_pre'

    YoutubeRe =
      %r{^https?://(?:(?:www|uk)\.)?youtube\.com/watch\?v=([\w\-]+)(?:&|$)}i

    def self.run(url, config)
      if match = YoutubeRe.match(url.url)
        url.enclosures.build(
          :title => url.title,
          :content_type => 'application/x-shockwave-flash',
          :enclosure_url => "http://www.youtube.com/v/#{match[1]}.swf")
      end
    end

  end

end
