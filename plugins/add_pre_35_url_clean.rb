require 'uri'

require 'postrank-uri'

require 'murlsh'

module Murlsh

  # Canonicalize and clean urls.

  class AddPre35UrlClean < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      Murlsh::failproof { url.url = clean(url.url)  if cleanable?(url.url) }
      Murlsh::failproof { url.via = clean(url.via)  if cleanable?(url.via) }
    end

    # Canonicalize and clean a url.
    #
    # Call PostRank::URI.clean and re-add a trailing slash to the path if it
    # was removed. Removing the trailing slash sometimes breaks urls.
    #
    # See https://github.com/postrank-labs/postrank-uri
    def self.clean(url)
      cleaned = PostRank::URI.clean(url)

      if URI(url).path.end_with? '/'
        cleaned_uri = URI(cleaned)
        unless cleaned_uri.path.end_with? '/'
          cleaned_uri.path << '/'
          cleaned = cleaned_uri.to_s
        end
      end

      cleaned
    end

    # Return true if the url can be cleaned (is http or https).
    def self.cleanable?(url); URI(url).scheme.to_s.match(/^https?$/i); end

  end

end
