module Murlsh

  # If the user has supplied a thumbnail url, adjust size and store it locally.
  class AddPre45SuppliedThumbnail < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      if url.thumbnail_url
        Murlsh.failproof do
          thumb_storage = ImgStore.new(config)

          stored_url = thumb_storage.store_url(url.thumbnail_url) do |i|
            max_side = config.fetch('thumbnail_max_side', 90)
            i.extend(ImageList).resize_down!(max_side)
          end

          url.thumbnail_url = stored_url  if stored_url
        end
      end
    end

  end

end
