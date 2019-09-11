class Product::Create
  include Product::Common

  def self.call(params:, user:)
    product = user.products.create(params)

    if product.valid?
      queue_workers(method: :create, product_id: product.id, images_ids: product.images.pluck(:id), user_id: user.id)
    end

    product
  end
end
