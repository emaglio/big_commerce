class Product::Delete
  include Product::Common

  def self.call(params:, user:)
    product = user.products.find(id: params[:id])
    images_ids = product.images.pluck(:id)
    product.delete

    unless product.persisted?
      queue_workers(method: :delete, product_id: params[:id], images_ids: images_ids, user_id: user.id)
    end

    product
  end
end
