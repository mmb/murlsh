require 'treetop'

module Murlsh

  # Search conditions builder for ActiveRecord conditions.
  class SearchConditions

    def initialize(q); @q = q; end

    # Search conditions builder for ActiveRecord conditions.
    def conditions
      unless q.to_s.empty?
        parser = SearchGrammarParser.new
        tokens = parser.parse(q).content
        search_cols = %w{name title url}

        likes = []
        params = []
        search_cols.product(tokens).each do |col,tok|
          likes << "LOWER(#{col}) LIKE ?"
          params << "%#{tok.downcase}%"
        end
        [likes.join(' OR ')].push(*params)
      else
        []
      end
    end

    attr_accessor :q
  end

end
