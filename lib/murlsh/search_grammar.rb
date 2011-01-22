# Autogenerated from a Treetop grammar. Edits may be lost.


module Murlsh

  module SearchGrammar
    include Treetop::Runtime

    def root
      @root ||= :query
    end

    module Query0
      def content; elements.map { |e| e.content }.compact.uniq; end
    end

    def _nt_query
      start_index = index
      if node_cache[:query].has_key?(index)
        cached = node_cache[:query][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      s0, i0 = [], index
      loop do
        i1 = index
        r2 = _nt_quoted_string
        if r2
          r1 = r2
        else
          r3 = _nt_whitespace
          if r3
            r1 = r3
          else
            r4 = _nt_string
            if r4
              r1 = r4
            else
              @index = i1
              r1 = nil
            end
          end
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Query0)

      node_cache[:query][start_index] = r0

      r0
    end

    module QuotedString0
    end

    module QuotedString1
      def content
        result = text_value[1..-2]
        result.empty? ? nil : result
      end
    end

    def _nt_quoted_string
      start_index = index
      if node_cache[:quoted_string].has_key?(index)
        cached = node_cache[:quoted_string][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('"', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure('"')
        r1 = nil
      end
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          if has_terminal?('\G[^"]', true, index)
            r3 = true
            @index += 1
          else
            r3 = nil
          end
          if r3
            s2 << r3
          else
            break
          end
        end
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        s0 << r2
        if r2
          if has_terminal?('"', false, index)
            r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('"')
            r4 = nil
          end
          s0 << r4
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(QuotedString0)
        r0.extend(QuotedString1)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:quoted_string][start_index] = r0

      r0
    end

    module Whitespace0
      def content; end;
    end

    def _nt_whitespace
      start_index = index
      if node_cache[:whitespace].has_key?(index)
        cached = node_cache[:whitespace][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      s0, i0 = [], index
      loop do
        if has_terminal?('\G[\\s]', true, index)
          r1 = true
          @index += 1
        else
          r1 = nil
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      if s0.empty?
        @index = i0
        r0 = nil
      else
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Whitespace0)
      end

      node_cache[:whitespace][start_index] = r0

      r0
    end

    module String0
      def content; text_value; end
    end

    def _nt_string
      start_index = index
      if node_cache[:string].has_key?(index)
        cached = node_cache[:string][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      s0, i0 = [], index
      loop do
        if has_terminal?('\G[^\\s]', true, index)
          r1 = true
          @index += 1
        else
          r1 = nil
        end
        if r1
          s0 << r1
        else
          break
        end
      end
      if s0.empty?
        @index = i0
        r0 = nil
      else
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(String0)
      end

      node_cache[:string][start_index] = r0

      r0
    end

  end

  class SearchGrammarParser < Treetop::Runtime::CompiledParser
    include SearchGrammar
  end


end