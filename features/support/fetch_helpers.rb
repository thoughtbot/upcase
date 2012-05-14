module FetchHelpers
  def stub_fetch_api
    FetchAPI::Order.stubs(:create)
    FetchAPI::Base.stubs(:basic_auth)
    FetchAPI::Order.stubs(:find).returns(stub(:link_full => "http://fetchurl"))
  end
end

World(FetchHelpers)
