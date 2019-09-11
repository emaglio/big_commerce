class Product::Create
  include Product::Common

  def self.call(params:, user:)
    product = user.products.find(params[:id])
    product.update(params)

    if product.valid?
      queue_workers(method: :update, product_id: product.id, images_ids: product.images.pluck(:id), user_id: user.id)
    end

    product
  end
end
