require 'active_record'

module Murlsh

  # Enclosure ActiveRecord.
  class Enclosure < ActiveRecord::Base
    belongs_to :url
  end

end
