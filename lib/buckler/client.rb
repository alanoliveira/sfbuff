# frozen_string_literal: true

module Buckler
  class Client
    class Error < StandardError; end
    class AccessDeniedError < Error; end
    class NotFoundError < Error; end
    class ServerUnderMaintenance < Error; end

    LOCALES = %w[en ja-jp pt-br].freeze

    class RequestError < Error
      attr_reader :response

      def initialize(response)
        @response = response
        super("Request failed with status #{response.status}")
      end
    end

    attr_accessor :credentials, :base_url, :user_agent
    attr_reader :locale

    def initialize(credentials, config = {})
      self.credentials = credentials
      self.base_url = config[:base_url] || Buckler.configuration.base_url
      self.user_agent = config[:user_agent] || Buckler.configuration.user_agent
      self.locale = config[:locale] || Buckler.configuration.locale
    end

    def locale=(val)
      @locale = LOCALES.include?(val) ? val : 'en'
    end

    def battlelog(short_id, page = 1)
      get("profile/#{short_id}/battlelog.json?sid=#{short_id}&page=#{page}")
    end

    def fighterslist(short_id: nil, fighter_id: nil)
      args = { short_id:, fighter_id: }.compact
      get("fighterslist/search/result.json?#{args.to_query}")
    end

    def under_maintenance?
      response = connection.head('/6/buckler/fighterslist/friend')
      response.status == 503
    end

    private

    def connection
      @connection ||= Faraday.new base_url do |faraday|
        faraday.path_prefix = "/6/buckler/_next/data/#{credentials.build_id}/#{locale}/"
        faraday.headers['User-Agent'] = user_agent
      end
    end

    def get(path)
      response = connection.get path do |req|
        req.headers['Cookie'] = cookies
      end

      handle_unexpected_response_status!(response) unless response.success?

      JSON.parse(response.body)
    end

    def cookies
      credentials.cookies.try do |cookies|
        cookies.map { |k, v| "#{k}=#{v}" }.join('; ')
      end
    end

    def handle_unexpected_response_status!(response)
      case response.status
      when 403, 401 then raise AccessDeniedError, response
      when 404
        under_maintenance? ? raise(ServerUnderMaintenance) : raise(NotFoundError, response.env.url)
      when 503 then raise ServerUnderMaintenance
      else raise RequestError, response
      end
    end
  end
end
