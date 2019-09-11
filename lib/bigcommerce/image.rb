module Bigcommerce
  class Image < Base

    def initialize(id:, body: nil, product_id:, user:)
      super(id: id, body: body, user: user)
      @product_id = product_id
    end

    private

    def api_url(id: nil)
      [PRODUCT_URL, @product_id, "images", id].compact.join("/")
    end
  end
end
