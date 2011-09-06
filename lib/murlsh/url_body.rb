require 'builder'
require 'uri'

module Murlsh

  # Url list page builder.
  class UrlBody < Builder::XmlMarkup
    include ::Murlsh::Markup

    def initialize(config, req, result_set, content_type='text/html')
      @config, @req, @result_set, @content_type = config, req, result_set,
        content_type
      super(:indent => @config['html_indent'] || 0)
    end

    # Get the href of a page in the same result set as this page.
    #
    # Return nil if page is invalid.
    def page_href(page)
      if page.to_i >= 1
        query = @req.params.dup
        query['p'] = page
        ::Murlsh.build_query(query)
      end
    end

    # Get the url of the previous page or nil if this is the first.
    def prev_href; page_href(@result_set.prev_page); end

    # Get the url of the next page or nil if this is the last.
    def next_href; page_href(@result_set.next_page); end

    # Yield body for Rack.
    def each; yield build; end

    # Url list page body builder.
    def build
      if defined?(@body)
        @body
      else
        declare! :DOCTYPE, :html

        @body = html(:lang => 'en') {
          headd
          body {
            menu
            search_form
            quick_search
            ul(:id => 'urls') {
              last = nil

              @result_set.results.each do |mu|
                ::Murlsh::Plugin.hooks('url_display_pre') do |p|
                  p.run mu, @req, @config
                end

                li(:id => "liu#{mu.id}") {
                  unless mu.same_author?(last)
                    avatar_url = ::Murlsh::Plugin.hooks('avatar').inject(
                      nil) do |url_so_far,plugin|
                      plugin.run url_so_far, mu, @config
                    end
                    div(:class => 'icon') {
                      murlsh_img :src => avatar_url, :text => mu.name
                    }  if avatar_url
                    div(mu.name, :class => 'name')  if
                      @config.fetch('show_names', false) and mu.name
                  end

                  if mu.thumbnail_url and not mu.same_thumbnail?(last)
                    murlsh_img :src => mu.thumbnail_url,
                      :text => mu.title_stripped, :class => 'thumb'
                  end

                  a mu.title_stripped, :href => mu.url, :class => 'm'

                  ::Murlsh::Plugin.hooks('url_display_add') do |p|
                    p.run self, mu, @config
                  end

                  last = mu
                }
              end
            }

            clear

            paging_nav
            add_form
            powered_by

            js
            div '', :id => 'bottom'
          }
        }
      end
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
        link :rel => 'first', :href => page_href(1)
        if p_href = prev_href
          link :rel => 'prev', :href => p_href
        end
        if n_href = next_href
          link :rel => 'next', :href => n_href
        end
      }
    end


    # Title builder.
    def titlee
      title(@config.fetch('page_title', '') +
        (@req['q'] ? " /#{@req['q']}" : ''))
    end

    # Menu builder.
    def menu
      self.p(:id => 'menu') {
        home_link ; text! ' | '
        feed_link ; text! ' | '
        random_link
      }
    end

    # Home link builder.
    def home_link; a 'Home', :href => @config.fetch('root_url'); end

    # Feed link builder.
    def feed_link
      a 'Feed', :href => @config.fetch('feed_file'), :class => 'feed'
    end

    # Random link builder.
    def random_link; a 'Random', :href => 'random', :rel => 'nofollow'; end

    # Quick search list builder.
    def quick_search
      if @config['quick_search']
        self.p {
          text! 'Quick search: '
          # can specify keys to be sorted first in quick_search_order config
          # key, those keys will be first in given order, any keys not there
          # will follow in natural sorted order
          order = @config['quick_search_order'] || []
          order += (@config['quick_search'].keys - order).sort
          order.each do |k|
            if v = @config['quick_search'][k]
              a "/#{k}", :href => "?q=#{::URI.escape(v)}" ; text! ' '
            end
          end
        }
      end
    end

    # Search form builder.
    def search_form
      form(:action => @config.fetch('root_url'), :method => 'get') {
        fieldset {
          form_input :id => 'q', :size => 32
          form_input :type => 'submit', :value => 'Search'
        }
      }
    end

    # Paging navigation.
    def paging_nav
      self.p {
        text! "Page #{@result_set.page}/#{@result_set.total_pages}"
        if p_href = prev_href
          text! ' | '; a 'previous', :href => p_href
        end
        if n_href = next_href
          text! ' | '; a 'next', :href => n_href
        end
      }
    end

    # Url add form builder.
    def add_form
      form(:action => 'url', :method => 'post') {
        fieldset(:id => 'add') {
          self.p {
            form_input :id => 'url', :label => 'Add URL', :size => 32,
              :required => ''
          }
          self.p { form_input :id => 'title', :label => 'Title', :size => 32 }
          self.p { form_input :id => 'via', :label => 'Via', :size => 32 }
          self.p {
            form_input :type => 'password', :id => 'auth', :label => 'Password',
              :size => 16, :required => ''
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
        text! 'Powered by '
        a 'murlsh', :href => 'https://github.com/mmb/murlsh'
      }
    end

    # Required javascript builder.
    def js; javascript(@config['js_compressed'] || @config['js_files']); end

  end

end
