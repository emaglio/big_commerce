module Bigcommerce
  class Category < Base
    # having this seems not really necessary since it's really
    # easy but it will make the maintenance and new feature adding cleaner
    private

    def api_url(id: nil)
      [CATEGORY_URL, id].compact.join("/")
    end
  end
end
