require 'spec_helper'

describe ShopifyController do
  it "doesn't add any users to github when it is not a backbone book sale" do
    client = stub(:add_team_member => nil)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>"cpytel"}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"NOTBACKBONE"}]
    client.should have_received(:add_team_member).never
  end

  it "doesn't add any users to github when there are blank usernames" do
    client = stub(:add_team_member => nil)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>" "}, {"name"=>"second-reader", "value"=>""}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"BACKBONE"}]
    client.should have_received(:add_team_member).never
  end

  it "adds any users to github when it is a backbone book sale" do
    client = stub(:add_team_member => nil)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>"cpytel"}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"BACKBONE"}]
    client.should have_received(:add_team_member).with(73110, "cpytel")
  end

  it "adds multiple users to github when it is a backbone book sale" do
    client = stub(:add_team_member => nil)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>"cpytel"}, {"name"=>"second-reader", "value"=>"reader2"}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"BACKBONE"}]
    client.should have_received(:add_team_member).with(73110, "cpytel")
    client.should have_received(:add_team_member).with(73110, "reader2")
  end

  it "still responds with 200 when username not found, and notify hoptoad" do
    Airbrake.stubs(:notify)
    client = stub()
    client.stubs(:add_team_member).raises(Octokit::NotFound)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>"cpytel"}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"BACKBONE"}]
    should respond_with(:ok)
    Airbrake.should have_received(:notify).once
  end

  it "still responds with 200 when Net::HTTPBadResponse, and notify hoptoad" do
    Airbrake.stubs(:notify)
    client = stub()
    client.stubs(:add_team_member).raises(Net::HTTPBadResponse)
    Octokit::Client.stubs(:new => client)
    post :order_paid, "note_attributes"=>[{"name"=>"first-reader", "value"=>"cpytel"}], "line_items"=>[{"id"=>198671572, "product_id"=>84369372, "quantity"=>1, "sku"=>"BACKBONE"}]
    should respond_with(:ok)
    Airbrake.should have_received(:notify).once
  end
end
