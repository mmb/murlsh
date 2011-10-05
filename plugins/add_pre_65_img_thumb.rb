module Murlsh

  # Get thumbnail for image urls if not already set.
  class AddPre65ImgThumb < Plugin

    @hook = 'add_pre'

    ImageContentType = %w{
      image/gif
      image/jpeg
      image/png
      }

    def self.run(url, config)
      if not url.thumbnail_url and url.content_type and
        ImageContentType.include?(url.content_type)
        Murlsh.failproof do
          thumb_storage = ImgStore.new(config)

          stored_url = thumb_storage.store_url(url.url) do |i|
            max_side = config.fetch('thumbnail_max_side', 90)
            i.extend(ImageList).resize_down!(max_side)
          end

          url.thumbnail_url = stored_url  if stored_url
        end
      end
    end

  end

end
