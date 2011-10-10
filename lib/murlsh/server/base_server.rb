require 'rack'

module Murlsh

  module Server

    # Superclass for servers.
    class BaseServer

      def initialize(config); @config = config; end

      def build_response(*args, &block)
        if block_given?
          ::Rack::Response.new *args, &block
        else
          ::Rack::Response.new *args
        end
      end

      attr_reader :config
    end

  end

end
