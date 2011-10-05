module Murlsh

  # If document has meta or link media:thumbnail use it as the thumbnail.
  class AddPre50MediaThumbnail < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      if not url.thumbnail_url and url.ask.doc
        url.ask.doc.xpath_search(%w{
          //meta[@rel='media:thumbnail']
          //link[@rel='media:thumbnail']
          }) do |node|
          unless node['href'].to_s.empty?
            Murlsh.failproof do
              thumb_storage = ImgStore.new(config)

              stored_url = thumb_storage.store_url(node['href']) do |i|
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
