class Image < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :url, presence: true

  # Bigcommerce API helper
  def build_body
    { image_url: url }
  end
end
