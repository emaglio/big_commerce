class Product
  module Common
    def queue_workers(method:, product_id:, images_ids:, user_id:)
      queue_product_worker(product_id: product_id, user_id: user_id)
      queue_images_workers(product_id: product.id, images_ids: images_ids, user_id: user_id)
    end

    def queue_product_worker(method:, product_id:, user_id:)
      Bigcommerce::ProductWorker.perform_async(method, product_id, user_id)
    end

    def queue_images_workers(method:, product_id:, images_ids: [], user_id:)
      return unless images_ids.any?

      images_ids.each do |id|
        Bigcommerce::ImageWorker.perform_async(method, product_id, id, user_id)
      end
    end
  end
end
