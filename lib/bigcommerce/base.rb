##
# Give base structure of Bigcommerce API class
#
module Bigcommerce
  class Base
    STORE_URL    = "/stores".freeze
    PRODUCT_URL  = "/catalog/products".freeze
    CATEGORY_URL = "/catalog/categories".freeze

    def initialize(id:, body: nil, user:)
      @id = id
      @body = body
      @user = user
    end

    attr_reader :user
    delegate :store, to: :user

    def create
      request.post(
        uri: uri,
        body: @body
      )
    end

    def update
      request.put(
        uri: uri(id: @id),
        body: @body
      )
    end

    def delete
      request.delete(
        uri: uri(id: @id)
      )
    end

    private

    def request
      @request ||= Request.new(
        # this values are either store in the user table
        # or in much better way would be in an integration model
        # but for now I think this makes sense
        store: @user.store,
        client_token: @user.client_token,
        access_token: @user.access_token
      )
    end

    def uri(id: nil)
      request.base_url + api_url(id: id)
    end

    # request url (after the prefix)
    def api_url
      raise NotImplemented
    end
  end
end
