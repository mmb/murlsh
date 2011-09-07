require 'active_record'

module Murlsh

  # Enclosure ActiveRecord.
  class Enclosure < ActiveRecord::Base
    belongs_to :url

    # Title with whitespace compressed and leading and trailing whitespace
    # stripped.
    def title_stripped; title.strip.gsub(/\s+/, ' '); end
  end

end
