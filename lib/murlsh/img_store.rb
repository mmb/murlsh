require 'digest/md5'
require 'open-uri'

require 'RMagick'

module Murlsh

  # Store images from various sources in asset storage.
  #
  # Storage is determined by store_asset plugins.
  class ImgStore

    # Store images from various sources in asset storage.
    #
    # Storage is determined by store_asset plugins.
    def initialize(config)
      @config = config
    end

    # Build headers to send with request.
    def headers
      result = {}
      result['User-Agent'] = config['user_agent']  if config['user_agent']
      result
    end

    # Fetch an image from a url and store it in asset storage.
    #
    # If a block is given the Magick::ImageList created will be yielded
    # before storage.
    #
    # Returns image url.
    def store_url(url, &block)
      open(url, headers) { |fin| store_img_data(fin.read, &block) }
    end

    # Store a blob of image data in asset storage.
    #
    # If a block is given the Magick::ImageList created will be yielded
    # before storage.
    #
    # Returns image url.
    def store_img_data(img_data, &block)
      img = Magick::ImageList.new.from_blob(img_data)
      yield img if block_given?
      store_img img
    end

    # Store a Magick::ImageList in asset storage.
    #
    # Returns image url.
    def store_img(img)
      img.extend(ImageList)  unless img.is_a?(ImageList)
      img_data = img.to_blob
      md5 = Digest::MD5.hexdigest(img_data)

      name = "img/thumb/#{md5}#{img.preferred_extension}"

      Plugin.hooks('store_asset') do |p|
        # run until one returns something
        if url = p.run(name, img_data, config)
          return url
        end
      end
      nil
    end

    attr_reader :config
  end

end
