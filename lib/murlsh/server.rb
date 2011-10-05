require 'rack'

module Murlsh

  # Superclass for servers.
  class Server

    def initialize(config); @config = config; end

    attr_reader :config
  end

  def build_response(*args &block); ::Rack::Response.new *args &block; end

end
