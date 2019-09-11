require 'rails_helper'
require_dependency "./spec/lib/bigcommerce/shared_examples/bigcommerce_api_handler"

RSpec.describe Bigcommerce::Image do
  let(:url_to_stub) do
    "/stores/#{store}/#{Bigcommerce::Request::API_VERSION}#{described_class::PRODUCT_URL}/1/images"
  end

  subject(:product) { described_class.new(id: id, body: {}, product_id: 1, user: user) }

  it_behaves_like :bigcommerce_api_handler
end
