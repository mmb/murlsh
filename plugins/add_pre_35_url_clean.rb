require 'uri'

require 'postrank-uri'

require 'murlsh'

# Patch PostRank::URI.normalize to not strip trailing slashes from the path.
module PostRank

  module URI

    module_function

    def normalize(uri, opts = {})
      u = parse(uri, opts)
      u.path = u.path.squeeze('/')
      # u.path = u.path.chomp('/') if u.path.size != 1
      u.query = nil if u.query && u.query.empty?
      u.fragment = nil
      u
    end

  end

end

module Murlsh

  # Canonicalize and clean urls.

  class AddPre35UrlClean < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      Murlsh::failproof { url.url = clean(url.url)  if cleanable?(url.url) }
      Murlsh::failproof { url.via = clean(url.via)  if cleanable?(url.via) }
    end

    # Canonicalize and clean a url using PostRank::URI.clean.
    #
    # PostRank::URI.normalize is patched to not strip trailing slashes from
    # the path (see above).
    #
    # See https://github.com/postrank-labs/postrank-uri
    def self.clean(url); PostRank::URI.clean(url); end

    # Return true if the url can be cleaned (is http or https).
    def self.cleanable?(url); URI(url).scheme.to_s.match(/^https?$/i); end

  end

end
