class Bigcommerce::ProductWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, retry: 3

  def perform(method, product_id, user_id)
    product = Product.find(image_id)
    user = User.find(user_id)

    Bigcommerce::Product.new(
      id: product_id,
      body: product.build_body
      user: user
    ).send(method)
  end
end
