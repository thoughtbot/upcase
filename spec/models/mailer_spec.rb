require 'spec_helper'

describe "Signup Email" do
  let(:purchase) { Factory.build(:purchase, :email => "joe@example.com", :name => "Joe Smith") }

  before(:all) do
    @email = Mailer.purchase_receipt(purchase)
  end

  it "is to the email passed in" do
    @email.should deliver_to(purchase.email)
  end

  it "contains the name in the mail body" do
    @email.should have_body_text(/#{purchase.name}/)
  end

  it "contains the price of the purchase" do
    @email.should have_body_text(/\$#{purchase.price}\.00/)
  end

  it "should have the correct subject" do
    @email.should have_subject(/Your receipt for #{purchase.product.name}/)
  end
end
