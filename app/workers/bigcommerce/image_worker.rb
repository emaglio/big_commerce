class Bigcommerce::ImageWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, retry: 3

  def perform(method, product_id, image_id, user_id)
    image = Image.find(image_id)
    user = User.find(user_id)

    Bigcommerce::Image.new(
      id: image_id,
      product_id: product_id,
      body: image.build_body
      user: user
    ).send(method)
  end
end
