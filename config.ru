require "bundler"
Bundler.setup
require "rack"
require "proxy_stack"

class Rack::PathPrefix
  def initialize(app, prefix)
    @app    = app
    @prefix = prefix
    @prefix = "/#{@prefix}" unless @prefix.start_with?('/')
    @prefix = @prefix[0...-1] if @prefix.end_with?('/')
  end

  def call(env)
    path_info = env['PATH_INFO']
    env['PATH_INFO'] = "#{@prefix}#{path_info}"
    @app.call(env)
  end
end

use Rack::MethodOverride
use Rack::PathPrefix, '/geo'
run ProxyStack.stackup
