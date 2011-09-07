require 'murlsh'

module Murlsh

  # Create video enclosures for Vimeo urls.
  class AddPre55EnclosureVimeo < Plugin

    @hook = 'add_pre'

    VimeoRe = %r{^http://(?:www\.)?vimeo\.com/(\d+)$}i

    def self.run(url, config)
      if match = VimeoRe.match(url.url)
        url.enclosures.build(
          :title => url.title,
          :content_type => 'application/x-shockwave-flash',
          :enclosure_url =>
            "http://vimeo.com/moogaloop.swf?clip_id=#{match[1]}")
      end
    end

  end

end
