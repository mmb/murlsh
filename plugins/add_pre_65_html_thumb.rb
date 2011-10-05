require 'plumnailer'

module Murlsh

  # Get thumbnail for HTML page urls with plumnailer if not already set.
  class AddPre65HtmlThumb < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      if not url.thumbnail_url and url.content_type and
        url.content_type[UriAsk::HtmlContentTypeRe]
        Murlsh.failproof do
          chooser = Plumnailer::Chooser.new
          choice = chooser.choose(url.url)

          if choice and choice.columns > 31 and choice.rows > 31
            max_side = config.fetch('thumbnail_max_side', 90)
            choice.extend(ImageList).resize_down!(max_side)

            thumb_storage = ImgStore.new(config)

            stored_url = thumb_storage.store_img(choice)
            url.thumbnail_url = stored_url  if stored_url
          end
        end
      end
    end

  end

end
