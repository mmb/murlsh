%w{
hpricot
}.each { |m| require m }

module Murlsh

  # Hpricot:Doc mixin.
  module Doc

    # Get the character set of the document.
    def charset
      %w{content-type Content-Type}.each do |ct|
        content_type = at("meta[@http-equiv='#{ct}']")
        unless content_type.nil?
          content = content_type['content']
          unless content.nil?
            charset = content[/charset=([\w_.:-]+)/, 1]
            return charset if charset
          end
        end
      end
      nil
    end

    # Check a list of xpaths in order and return the inner html of the first
    # one that is not nil.
    def xpath_search(xpaths)
      xpaths.to_a.each do |xpath|
        selection = (self/xpath).first
        return selection unless selection.nil?
      end
      nil
    end

    # Get the title of the document.
    def title
      node = xpath_search %w{//html/head/title //head/title //html/title //title}
      node.inner_html unless node.nil?
    end

    # Get the meta description of the document.
    def description
      node = xpath_search "//html/head/meta[@name='description']"
      node['content'] unless node.nil?
    end

  end

end
