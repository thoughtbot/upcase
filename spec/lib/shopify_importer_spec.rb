require 'spec_helper'

describe ShopifyImporter do
  it 'creates purchases without any of the side effects' do
    product = create(:product)
    coupon = create(:coupon)
    email = 'jwills@example.com'
    name = 'Jason Williams'
    street = '14 Cool St'
    address2 = '#5b'
    city = 'Springfield'
    state = 'IL'
    zip = '02928'
    country = 'US'
    company = 'Madeup Names'

    csv = <<-CSV
Variant,Name,Email,Financial Status,Paid at,Fulfillment Status,Fulfilled at,Accepts Marketing,Currency,Subtotal,Shipping,Taxes,Total,Discount Code,Discount Amount,Shipping Method,Created at,Lineitem quantity,Lineitem name,Lineitem price,Lineitem compare at price,Lineitem sku,Lineitem requires shipping,Lineitem taxable,Lineitem fulfillment status,Billing Name,Billing Street,Billing Address1,Billing Address2,Billing Company,Billing City,Billing Zip,Billing Province,Billing Country,Billing Phone,Shipping Name,Shipping Street,Shipping Address1,Shipping Address2,Shipping Company,Shipping City,Shipping Zip,Shipping Province,Shipping Country,Shipping Phone,Notes,Note Attributes,Cancelled at
individual,#1230,#{email},paid,2012-01-01 11:13:25 -0500,fulfilled,2012-01-01 11:13:26 -0500,yes,USD,15.00,0.00,0.00,15.00,#{coupon.code},#{coupon.amount},"",2012-01-01 11:13:13 -0500,1,#{product.name},15.00,"",#{product.sku},false,false,fulfilled,#{name},#{street},#{street},#{address2},#{company},#{city},#{zip},#{state},#{country},,#{name},#{street},#{street},#{address2},,#{city},#{zip},#{state},#{country},,,"",
company,#1231,paypal@twmills.com,paid,2012-01-01 14:09:11 -0500,fulfilled,2012-01-01 14:09:11 -0500,yes,USD,15.00,0.00,0.00,15.00,"",0.00,"",2012-01-01 14:09:01 -0500,1,Vim for Rails Developers - For Yourself,15.00,"",#{product.sku},false,false,fulfilled,twmills LLC,9605 Kangaroo Lane,9605 Kangaroo Lane,,twmills LLC,Austin,78748,TX,US,,twmills LLC,9605 Kangaroo Lane,9605 Kangaroo Lane,,twmills LLC,Austin,78748,TX,US,,,"",
    CSV

    csv_file = Tempfile.new('csv')
    csv_file.write(csv)
    csv_file.close
    csv_file_name = csv_file.path

    importer = ShopifyImporter.new(csv_file_name)
    importer.run

    Purchase.should be_exist(product_id: product.id,
                             variant: 'individual',
                             name: name,
                             email: email,
                             organization: company,
                             address1: street,
                             address2: address2,
                             city: city,
                             state: state,
                             zip_code: zip,
                             coupon_id: coupon.id,
                             paid: true,
                             payment_method: 'shopify',
                             country: country,
                             payment_transaction_id: '#1230')
    Purchase.should be_exist(payment_transaction_id: '#1231',
                             coupon_id: nil,
                             variant: 'company',
                             product_id: product.id)
  end
end
