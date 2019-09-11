module Bigcommerce
  class Product < Base
    private

    def api_url(id: nil)
      [PRODUCT_URL, id].compact.join("/")
    end
  end
end
