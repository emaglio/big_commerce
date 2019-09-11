module Bigcommerce
  class Request
    include Errors
    # this could be saved into ENV vars instead of constant here
    API_VERSION = 'v3'.freeze
    API_ENDPOINT = 'https://api.bigcommerce.com'.freeze

    def initialize(store:, client_token:, access_token:)
      @client_token = client_token
      @access_token = access_token
      @store_hash   = store
    end

    def post(uri:, body:)
      json_body = body.is_a?(String) ? body : body.to_json
      request(method: :post, uri: uri, body: json_body)
    end

    def put(uri:, body:)
      json_body = body.is_a?(String) ? body : body.to_json
      request(method: :put, uri: uri, body: json_body)
    end

    def delete(uri:)
      request(method: :delete, uri: uri)
    end

    def base_url
      ["/stores", @store_hash, API_VERSION].join('/')
    end

    private

    def connection
      @connection ||= Faraday.new do |f|
        f.adapter :net_http
        f.url_prefix = API_ENDPOINT
        f.headers['Content-Type'] = 'application/json'
        f.headers['Accept'] = 'application/json'
        f.headers['X-Auth-Client'] = @client_token
        f.headers['X-Auth-Token'] = @access_token
      end
    end

    def request(method:, uri:, body: nil)
      response = connection.send(method) do |request|
        request.url verify_uri(uri: uri)
        request.body = body if body
      end
      handle_error(method: method, uri: uri, response: response)
      response.body
    end

    # Not covering all the possible errors in the API
    def handle_error(method:, uri:, response:)
      # success or deleted successfully
      return if [200, 204].include? response.status

      error_message = "Error after request #{method}/#{uri}"
      error = case response.status
              when 401
                AuthError
              when 404
                NotFoundError
              when 409
                DuplicateError
              when 422
                InvalidObjectError
              else
                UnknownError
              end

      raise error, error_message
    end

    def verify_uri(uri:)
      # it could be something more than this...
      # for example we could consider to have a list of end_points
      # and validate that uri is included in it otherwise we will raise
      # an error for developers and avoid issue in production
      URI.parse(uri)
    end

    def parse_response(response:)
      # this can be improved adding some check about the parsing before raising an error
      JSON.parse(response)
    end
  end
end
