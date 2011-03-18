require 'uri'

require 'murlsh'

module Murlsh

  # Google Code project page titles are not very descriptive so add summary
  # from page.
  class AddPre60GoogleCodeTitle < Plugin

    @hook = 'add_pre'

    GoogleCodeRe = %r{^http://code\.google\.com/p/[\w-]+/$}i

    def self.run(url, config)
      if (not url.user_supplied_title? and url.url.to_s[GoogleCodeRe] and
        url.ask.doc)
        url.ask.doc.xpath_search("//a[@id='project_summary_link']") do |node|
          summary = node.inner_html.to_s
          url.title << " - #{url.ask.decode(summary)}"  unless summary.empty?
        end
      end
    end

  end

end
