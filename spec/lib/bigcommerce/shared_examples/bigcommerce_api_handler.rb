shared_examples :bigcommerce_api_handler do |api_url|
  let(:id)                   { 1 }
  let(:faraday_response)     { double(body: {}, status: 200) }
  let(:store)                { 1234 }
  let(:user)                 { double(store: store, client_token: "client_token", access_token: "access_token") }
  let(:default_api_response) { { data: {} }.to_json }

  def stub_api_request(method, uri, status = 200, body = default_api_response)
    url = Bigcommerce::Request::API_ENDPOINT + uri
    stub_request(method, url).to_return(status: status, body: body)
  end

  context '#create' do
    let(:method)      { :post }

    before { stub_api_request(method, url_to_stub) }

    it 'request through the correct url' do
      expect(subject.create).to eq default_api_response
    end
  end

  context '#update' do
    let(:method) { :put }

    before { stub_api_request(method, url_to_stub + "/#{id}") }

    it 'request through the correct url' do
      expect(subject.update).to eq default_api_response
    end
  end

  context '#delete' do
    let(:method) { :delete }

    before { stub_api_request(method, url_to_stub + "/#{id}") }

    it 'request through the correct url' do
      expect(subject.delete).to eq default_api_response
    end
  end
end
