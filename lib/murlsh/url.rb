require 'uri'

require 'active_record'

module Murlsh

  # URL ActiveRecord.
  class Url < ActiveRecord::Base
    has_many :enclosures
    validates_format_of :url, :with => URI.regexp

    # Get the title of this url.
    def title
      ta = read_attribute(:title)
      ta = nil  if ta and ta.empty?
      
      ua = read_attribute(:url)
      ua = nil  if ua and ua.empty?

      ta || ua || 'title missing'
    end

    # Title with whitespace compressed and leading and trailing whitespace
    # stripped.
    def title_stripped; title.to_s.strip.gsub(/\s+/, ' '); end

    # Return true if this url has the same author as another url.
    def same_author?(other)
      other and other.email and other.name and
        email and name and email == other.email and name == other.name
    end

    # Return true if this url has the same thumbnail url as another url.
    def same_thumbnail?(other)
      other and thumbnail_url == other.thumbnail_url
    end

    def ask
      if !defined?(@ask) or @ask.to_s != url
        @ask = URI(url).extend(Murlsh::UriAsk)
      end
      @ask
    end

    attr_accessor :user_supplied_title
    alias :user_supplied_title? :user_supplied_title
  end

end
