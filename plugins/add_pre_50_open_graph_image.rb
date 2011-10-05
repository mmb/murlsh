require 'uri'

module Murlsh

  # If document has <meta property="og:image"> use it as the thumbnail.
  class AddPre50OpenGraphImage < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      if not url.thumbnail_url and url.ask.doc
        url.ask.doc.xpath_search("//meta[@property='og:image']") do |node|
          unless node['content'].to_s.empty?
            og_image_url = node['content']
            Murlsh.failproof do
              # youtube leaves out scheme: for some reason
              if og_image_url[%r{^//}]
                og_image_url = "#{URI(url.url).scheme}:#{og_image_url}"
              end
              thumb_storage = ImgStore.new(config)

              stored_url = thumb_storage.store_url(og_image_url) do |i|
                max_side = config.fetch('thumbnail_max_side', 90)
                i.extend(ImageList).resize_down!(max_side)
              end

              url.thumbnail_url = stored_url  if stored_url
            end
          end
        end
      end
    end

  end

end
