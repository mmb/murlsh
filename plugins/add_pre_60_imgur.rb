module Murlsh

  # Set the title of imgur images.
  class AddPre60Imgur < Plugin

    @hook = 'add_pre'

    ImgurRe = %r{^http://(?:i\.)?imgur\.com/([a-z\d]+)(\.(?:jpe?g|gif|png))$}i

    def self.run(url, config)
      if not url.user_supplied_title? and match = ImgurRe.match(url.url)
        url.title = "imgur/#{match[1]}s#{match[2]}"
      end
    end

  end

end
