require 'builder'

module Murlsh

  # Url list page builder.
  class UrlBody < Builder::XmlMarkup
    include Murlsh::Markup

    def initialize(config, req, content_type='text/html')
      @config, @req, @q, @content_type =
        config, req, req.params['q'], content_type
      super(:indent => @config['html_indent'] || 0)
    end

    # Fetch urls based on query string parameters.
    def urls
      Murlsh::Url.all(:conditions => search_conditions, :order => 'id DESC',
        :limit =>  @req.params['n'] ? @req.params['n'].to_i :
          @config.fetch('num_posts_page', 100))
    end

    # Search conditions builder for ActiveRecord conditions.
    def search_conditions
      if @q
        search_cols = %w{name title url}
        [search_cols.map { |x| "MURLSHMATCH(#{x}, ?)" }.join(' OR ')].push(
          *[@q] * search_cols.size)
      else
        []
      end
    end

    # Url list page body builder.
    def each
      declare! :DOCTYPE, :html

      yield html(:lang => 'en') {
        headd
        body {
          ul(:id => 'urls') {
            li { feed_icon ; search_form }

            last = nil
            urls.each do |mu|
              li {
                unless mu.same_author?(last)
                  avatar_url = Murlsh::Plugin.hooks('avatar').inject(
                    nil) do |url_so_far,plugin|
                    plugin.run(url_so_far, mu, @config)
                  end
                  div(:class => 'icon') {
                    murlsh_img :src => avatar_url, :text => mu.name
                  }  if avatar_url
                  div(mu.name, :class => 'name')  if
                    @config.fetch('show_names', false) and mu.name
                end

                if mu.thumbnail_url
                  murlsh_img :src => mu.thumbnail_url,
                    :text => mu.title_stripped, :class => 'thumb'
                end

                a mu.title_stripped, :href => mu.url, :class => 'm'

                Murlsh::Plugin.hooks('url_display_add') do |p|
                  p.run self, mu, @config
                end

                last = mu
              }
            end

            li { add_form }
          }

          clear
          powered_by
          js
          div '', :id => 'bottom'
        }
      }
    end

    # Head builder.
    def headd
      head {
        titlee
        meta :'http-equiv' => 'Content-Type', :content => @content_type
        metas(@config.find_all { |k,v| k =~ /^meta_tag_/ and v }.
          map { |k,v| [k.sub('meta_tag_', ''), v] })
        css(@config['css_compressed'] || @config['css_files'])
        atom @config.fetch('feed_file')
      }
    end

    # Title builder.
    def titlee
      title(@config.fetch('page_title', '') + (@q ? " /#{@q}" : ''))
    end

    # Feed icon builder.
    def feed_icon
      div(:class => 'icon') {
        a('feed', :href => @config.fetch('feed_file'), :class => 'feed')
      }
    end

    # Search form builder.
    def search_form
      form(:action => '', :method => 'get') {
        fieldset {
          form_input :id => 'q', :size => 32, :value => @q
          form_input :type => 'submit', :value => 'Regex Search'
        }
      }
    end

    # Url add form builder.
    def add_form
      form(:action => '', :method => 'post') {
        fieldset(:id => 'add') {
          self.p { form_input :id => 'url', :label => 'Add URL', :size => 32 }
          self.p { form_input :id => 'via', :label => 'Via', :size => 32 }
          self.p {
            form_input :type => 'password', :id => 'auth', :label => 'Password',
              :size => 16
            form_input :id => 'submit', :type => 'button', :value => 'Add'
          }
        }
      }
    end

    # Clear div builder.
    def clear; div(:style => 'clear : both') { }; end

    # Powered by builder.
    def powered_by
      self.p {
        text! 'powered by '
        a 'murlsh', :href => 'http://github.com/mmb/murlsh/'
      }
    end

    # Required javascript builder.
    def js; javascript(@config['js_compressed'] || @config['js_files']); end

  end

end
