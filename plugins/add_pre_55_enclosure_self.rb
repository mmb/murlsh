require 'murlsh'

module Murlsh

  # Create enclosures for content types that can directly become enclosures.
  class AddPre55EnclosureSelf < Plugin

    @hook = 'add_pre'

    # Content types that can be enclosures.
    ContentTypes = %w{
      application/pdf
      audio/mpeg
      image/gif
      image/jpeg
      image/png
      }

    def self.run(url, config)
      if ContentTypes.include?(url.content_type)
        url.enclosures.build(
          :content_length => url.content_length,
          :title => url.title,
          :content_type => url.content_type,
          :enclosure_url => url.url)
      end
    end

  end

end
