class Product < ApplicationRecord
  ATTRIBUTES_TO_SYNC = %i[name type weight categories price].freeze

  # considering that Product form accepts nested information for
  # images and categories
  has_many :images
  has_many :categories

  # I usually don't use AM validations (or better I prefer don't use it)
  # I much prefer dry-validation
  validates ATTRIBUTES_TO_SYNC, presence: true

  # Bigcommerce API helper
  def build_body
    values = ATTRIBUTES_TO_SYNC.map do |attribute|
      categories.pluck(:id) and next if attribute == :categories
      send(attribute)
    end

    Hash[Product::ATTRIBUTES_TO_SYNC.zip(values)]
  end
end
