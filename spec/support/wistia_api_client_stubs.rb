module WistiaApiClientStubs
  def stub_wistia_api_client(response:)
    client = instance_double("WistiaApiClient::Media")
    allow(client).to receive(:list).and_return(response)
    allow(client).to receive(:show).and_return(response)
    allow(WistiaApiClient::Media).to receive(:new).and_return(client)
  end
end
