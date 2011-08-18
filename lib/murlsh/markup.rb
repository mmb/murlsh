module Murlsh

  # Helper mixin for XML builder.
  module Markup

    # Javascript link builder. Takes list of script urls.
    #
    # Options:
    # * :prefix - prefix to append to all script urls
    def javascript(sources, options={})
      Array(sources).each do |src|
        script '', :type => 'text/javascript',
          :src => "#{options[:prefix]}#{src}"
      end
    end

    # Image tag builder.
    #
    # Options:
    # * :href - make the image a link to this url
    # * :prefix - prefix to append to all image urls
    # * :size - image size if square or [w, h]
    # * :text - text for alt and title tag
    #
    # Any other options in hash will be added as attributes.
    def murlsh_img(options={})
      img_convert_prefix options
      img_convert_size options
      img_convert_text options
      img_convert_data_uri options

      if options[:href]
        a(:href => options[:href]) {
          options.delete :href
          img options
        }
      else
        img options
      end
    end

    # ATOM feed link builder.
    def atom(href)
      link :rel => 'alternate', :type => 'application/atom+xml', :href => href
    end

    # CSS link builder.
    #
    # Options:
    # * :media - optional media attribute
    # * :prefix - prepended to all CSS urls
    def css(hrefs, options={})
      Array(hrefs).each do |href|
        attrs = {
          :href => "#{options[:prefix]}#{href}",
          :rel => 'stylesheet',
        }
        attrs[:media] = options[:media]  if options[:media]
        link attrs
      end
    end

    # Meta tag builder. Takes a hash of name => content.
    def metas(tags)
      tags.each { |k,v| meta :name => k, :content => v }
    end

    # Form input builder.
    def form_input(options)
      if options[:id]
        if options[:label]
          label_class = options[:required] ? 'required' : 'optional'
          label options[:label], :for => options[:id], :class => label_class
        end
        options[:name] ||= options[:id]
      end

      options.delete :label

      options[:type] ||= 'text'

      if %w{text password}.include?(options[:type]) and @req and
        not @req[options[:name]].to_s.empty?
        options[:value] = @req[options[:name]]
      end

      input options
    end

    private

    def img_convert_prefix(options)
      if options.has_key?(:prefix) and options.has_key?(:src)
        options[:src] = options[:prefix] + options[:src]
        options.delete :prefix
      end
    end

    def img_convert_size(options)
      if options.has_key?(:size)
        if options[:size].kind_of?(Array) and options[:size].size == 2
          options[:width], options[:height] = options[:size]
        else
          options[:width] = options[:height] = options[:size]
        end
        options.delete :size
      end
    end

    def img_convert_text(options)
      if options.has_key?(:text)
        options[:alt] = options[:title] = options[:text]
        options.delete :text
      end
    end

    # If given options[:data_uri_prefix], render the image as a data uri with
    # the base64 encoded image data directly in the src attribute.
    #
    # Only works if options[:src] is a relative url.
    #
    # Local image file path is site root (current working directory) +
    # options[:data_uri_prefix] + options[:src].
    #
    # Options:
    # * :src - image src
    # * :data_uri_prefix - prefix for finding images on local filesystem
    # * :max_size - images larger than this will not be converted to data uris
    def img_convert_data_uri(options)
      if options[:data_uri_prefix]
        Murlsh::failproof do
          # try to prevent getting outside current working directory
          img_path = File.join(Dir.getwd, File.expand_path(
            File.join(options[:data_uri_prefix], options[:src]), '/'))
          img_size = File.size(img_path)

          unless size == 0 or 
            (options[:max_size] and size > options[:max_size])
            options[:src] = Magick::ImageList.new(img_path).extend(
              Murlsh::ImageList).data_uri

            options.delete :data_uri_prefix
            options.delete :max_size
          end
        end
      end
    end

  end

end
