class Category < ApplicationRecord
  belongs_to :user
  has_many :product

  validates :name, presence: true

  # Bigcommerce API helper
  def build_body
    { name: name }
  end
end
