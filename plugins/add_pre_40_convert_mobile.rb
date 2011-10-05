module Murlsh

  # Convert urls specifically for use on mobile devices into their non-mobile
  # equivalents.
  class AddPre40ConvertMobile < Plugin

    @hook = 'add_pre'

    TwitterRe = %r{^(http://)mobile\.(twitter\.com/.*)$}i
    WikipediaRe = %r{^(http://[a-z]+\.)m\.(wikipedia\.org/.*)$}i

    def self.unmobile(url)
      case
        when match = TwitterRe.match(url); "#{match[1]}#{match[2]}"
        when match = WikipediaRe.match(url); "#{match[1]}#{match[2]}"
        else; url
      end
    end

    def self.run(url, config)
      url.url = unmobile(url.url)
      url.via = unmobile(url.via)
    end

  end

end
