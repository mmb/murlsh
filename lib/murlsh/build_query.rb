require 'uri'

module Murlsh

  module_function

  # Query string builder. Takes hash of query string variables.
  def build_query(h)
    h.empty? ? '' : '?' + h.map { |k,v| URI.escape("#{k}=#{v}") }.join('&')
  end

end
