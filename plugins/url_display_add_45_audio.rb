module Murlsh

  # Add HTML5 audio tag to audio urls.
  class UrlDisplayAdd45Audio < Plugin

    @hook = 'url_display_add'

    AudioContentTypes = %w{
      application/ogg
      audio/mpeg
      audio/ogg
      }

    def self.run(markup, url, config)
      if AudioContentTypes.include?(url.content_type)
        markup.text! ' '
        markup.audio(
          :controls => 'controls',
          :preload => 'none',
          :src => url.url) { }
      end
    end

  end

end
