module Murlsh

  # If there is no page title, check for meta og:title.
  class AddPre55OpenGraphTitle < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      if url.title == url.url and not url.user_supplied_title? and url.ask.doc
        url.ask.doc.xpath_search("//meta[@property='og:title']") do |node|
          url.title = node['content']  unless node['content'].to_s.empty?
        end
      end
    end

  end

end
