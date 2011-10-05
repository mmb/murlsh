module Murlsh

  # Try to fetch the content length, content type and title of a url.
  class AddPre50LookupContentTypeTitle < Plugin

    @hook = 'add_pre'

    def self.run(url, config)
      headers = {}
      headers['User-Agent'] = config['user_agent']  if config['user_agent']

      content_length = url.ask.content_length(:headers => headers)
      if content_length and not content_length.empty?
        url.content_length = content_length
      end

      url.content_type = url.ask.content_type(:headers => headers)

      unless url.user_supplied_title?
        url.title = url.ask.title(:headers => headers)
      end
    end

  end

end
