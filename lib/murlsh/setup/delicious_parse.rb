require 'open-uri'
require 'time'
require 'uri'

require 'nokogiri'

module Murlsh

  module Setup

    module_function

    # Parse a delicious xml export and yield a hash for each bookmark.
    #
    # To export your delicious bookmarks:
    #   curl https://user:password@api.del.icio.us/v1/posts/all > delicious.xml
    def delicious_parse(source)
      doc = Nokogiri::XML(open(source))

      doc.xpath('//post').each do |p|
        result = {}
        p.each { |k,v| result[k.to_sym] = v }

        result[:tag] = result[:tag].split
        result[:time] = Time.parse(result[:time])

        # extract via information from extended
        result[:via] = result[:extended].chomp(')')[%r{via\s+([^\s]+)}, 1]
        result[:via_url] = begin
          if result[:via] and
            %w{http https}.include?(URI(result[:via]).scheme.to_s.downcase)
            result[:via]
          end
        rescue URI::InvalidURIError
        end

        yield result
      end
    end

  end

end
