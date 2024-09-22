# frozen_string_literal: true

# BEGIN
require 'forwardable'
require 'uri'

class Url
  extend Forwardable
  include Comparable

  def_delegators :@uri, :scheme, :host, :port

  def initialize(url_string)
    @uri = URI.parse(url_string)
    @query_params_hash = parse_query_params(@uri.query)
  end

  def query_params
    @query_params_hash
  end

  def query_param(key, default = nil)
    @query_params_hash[key.to_sym] || default
  end

  def <=>(other)
    return nil unless other.is_a?(Url)
    [scheme, host, port, query_params] <=> [other.scheme, other.host, other.port, other.query_params]
  end

  protected

  def parse_query_params(query)
    params = {}
    if query
      query.split('&').each do |pair|
        key, value = pair.split('=')
        params[key.to_sym] = value
      end
    end
    params
  end
end

# END
