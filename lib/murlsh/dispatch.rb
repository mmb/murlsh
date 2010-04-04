%w{
active_record
rack

murlsh
}.each { |m| require m }

module Murlsh

  # Dispatch requests.
  class Dispatch

    # Set up database connection and dispatch table.
    def initialize(config)
      @config = config

      ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3', :database => @config.fetch('db_file'))

      db = ActiveRecord::Base.connection.instance_variable_get(:@connection)

      url_server = Murlsh::UrlServer.new(@config, db)
      flickr_server = Murlsh::FlickrServer.new(@config)

      root_path = URI(@config.fetch('root_url')).path

      @dispatch = [
        [/^GET #{root_path}(url)?$/, url_server.method(:get)],
        [/^POST #{root_path}(url)?$/, url_server.method(:post)],
        [/^GET \/flickr$/, flickr_server.method(:get)],
      ]
    end

    # Figure out which method will handle request.
    def dispatch(req)
      method_match = @dispatch.find do |rule|
        rule[0].match("#{req.request_method} #{req.path}")
      end

      method_match ? method_match[1] : self.method(:not_found)
    end

    # Rack call.
    def call(env)
      req = Rack::Request.new(env)
      dispatch(req).call(req).finish
    end

    # Called if the request is not found.
    def not_found(req)
      Rack::Response.new("<p>#{req.url} not found</p>

<p><a href=\"#{@config['root_url']}\">root<a></p>
",
        404, { 'Content-Type' => 'text/html' })
    end

  end

end
