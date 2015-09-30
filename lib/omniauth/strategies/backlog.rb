# -*- coding: utf-8 -*-
require 'omniauth-oauth2'


module OmniAuth
  module Strategies
    class Backlog < OmniAuth::Strategies::OAuth2
      option :name, 'backlog'

      option :space_id, nil

      option :authorize_params, {
        :response_type => 'code',
      }

      option :client_options, {
        :authorize_url => '/OAuth2AccessRequest.action',
        :token_url => '/api/v2/oauth2/token',
        :proxy => ENV['http_proxy'] ? URI(ENV['http_proxy']) : nil
      }

      def setup_phase
        self.options.space_id = session['omniauth.backlog.space_id'] if session['omniauth.backlog.space_id'].present?
      end
      
      def deep_symbolize(options)
        hash = super(options)
        if ! hash.has_key?(:site)
          if self.options.space_id == nil
            raise 'Backlog space is missing.'
          end
          hash[:site] = 'https://' + self.options.space_id + '.backlog.jp'
        end
        hash
      end

      uid{ raw_info['userId'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['mailAddress']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v2/users/myself').parsed
      end
    end
  end
end