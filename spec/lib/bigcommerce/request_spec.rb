require 'rails_helper'

RSpec.describe Bigcommerce::Request do
  let(:store)                { 1234 }
  let(:client_token)         { "client_token" }
  let(:access_token)         { "access_token" }
  let(:default_api_response) { { data: {} }.to_json }
  let(:response_status)      { 200 }

  subject(:request) do
    Bigcommerce::Request.new(
      store: store,
      client_token: client_token,
      access_token: access_token
    )
  end

  describe '#base_url' do
    subject(:base_url) { request.send(:base_url) }

    it { is_expected.to eq "/stores/1234/v3" }
  end

  def stub_api_request(method, uri, status = response_status, body = default_api_response)
    url = described_class::API_ENDPOINT + uri
    stub_request(method, url).to_return(status: status, body: body)
  end

  shared_examples :success_request do |type|
    let(:body) { {some: 'body'} }
    let(:uri)  { "/some/uri" }

    before { stub_api_request(type, uri) }

    it { is_expected.to eq default_api_response }
  end

  context '#post' do
    subject(:post) { request.post(uri: uri, body: body) }

    it_behaves_like :success_request, :post
  end

  context '#put' do
    subject(:put) { request.put(uri: uri, body: body) }

    it_behaves_like :success_request, :put
  end

  context '#delete' do
    subject(:delete) { request.delete(uri: uri) }

    it_behaves_like :success_request, :delete
  end

  context 'error_handleing' do
    shared_examples :raises_error do |error|
      let(:any_request) { request.post(uri: "/uri", body: {}.to_json) }

      before { stub_api_request(:post, '/uri') }

      it do
        expect { any_request }.to raise_error(error)
      end
    end

    context '#401' do
      let(:response_status) { 401 }

      it_behaves_like :raises_error, described_class::AuthError
    end

    context '#404' do
      let(:response_status) { 404 }

      it_behaves_like :raises_error, described_class::NotFoundError
    end

    context '#409' do
      let(:response_status) { 409 }

      it_behaves_like :raises_error, described_class::DuplicateError
    end

    context '#422' do
      let(:response_status) { 422 }

      it_behaves_like :raises_error, described_class::InvalidObjectError
    end

    context '#000' do
      let(:response_status) { 000 }

      it_behaves_like :raises_error, described_class::UnknownError
    end
  end
end
