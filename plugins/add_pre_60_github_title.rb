require 'uri'

module Murlsh

  # Github project page titles are not very descriptive so add meta description
  # to title.
  class AddPre60GithubTitle < Plugin

    @hook = 'add_pre'

    GithubRe = %r{^https?://github\.com/\w+/[\w.-]+/?$}i

    def self.run(url, config)
      if not url.user_supplied_title? and url.url.to_s[GithubRe]
        unless url.ask.description.empty?
          url.title << " - #{url.ask.description}"
        end
      end
    end

  end

end
