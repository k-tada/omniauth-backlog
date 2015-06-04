require 'omniauth-oauth2'
require 'cgi'


module OmniAuth
  module Strategies
    class Backlog < OmniAuth::Strategies::OAuth2
      args [:space, :client_id, :client_secret]

      option :name, 'backlog'

      option :space, nil

      option :authorize_params, {
        :response_type => 'code',

      }
      option :client_options, {
        # :authorize_path => '/api/v2/oauth2/token',
        :authorize_url => '/OAuth2AccessRequest.action',
        :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil
      }

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(client_options))
      end

      def client_options
        params = {
          :site => 'https://' + options.space + '.backlog.jp',
          :authorize_path => '/OAuth2AccessRequest.action',
        }
        params = params.merge(options.client_options)
        params
      end

    end
  end
end