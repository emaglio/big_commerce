require 'rails_helper'
require_dependency "./spec/lib/bigcommerce/shared_examples/bigcommerce_api_handler"

RSpec.describe Bigcommerce::Product do
  let(:url_to_stub) do
    "/stores/#{store}/#{Bigcommerce::Request::API_VERSION}#{described_class::PRODUCT_URL}"
  end

  subject(:product) { described_class.new(id: id, body: {}, user: user) }

  it_behaves_like :bigcommerce_api_handler
end
