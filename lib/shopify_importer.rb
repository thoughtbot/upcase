class ShopifyImporter
  def self.run(csv_file)
    new(csv_file).run
  end

  def initialize(csv_file)
    @csv_file = csv_file
  end

  def run
    Purchase.transaction do
      CSV.foreach(@csv_file, headers: :first_row) do |row|
        next if row['Fulfillment Status'].blank?

        product = Product.find_by_sku(row['Lineitem sku'])
        if product
          Purchase.connection.execute(sql_for_row(product, row))
        else
          $stderr.puts "failed to find the product with sku #{row['Lineitem sku']} for the row:\n\t#{row.inspect}"
        end
      end
    end
  end

  private

  def sql_for_row(product, row)
    email = row['Email']
    coupon = Coupon.find_by_code(row['Discount Code'])
    attributes = {
      product_id: product.try(:id),
      variant: 'individual',
      name: row['Billing Name'],
      email: email,
      organization: row['Billing Company'],
      address1: row['Billing Address1'],
      address2: row['Billing Address2'],
      city: row['Billing City'],
      state: row['Billing Province'],
      zip_code: row['Billing Zip'],
      lookup: Digest::MD5.hexdigest("#{email}#{product.id}#{Time.now}\n").downcase,
      coupon_id: coupon.try(:id),
      readers: '',
      paid: row['Financial Status'] == 'paid',
      payment_method: 'shopify',
      country: row['Billing Country'],
      payment_transaction_id: row['Name'],
      updated_at: row['Fulfilled at'],
      created_at: row['Fulfilled at']
    }

    sql_for_attributes(attributes)
  end

  def sql_for_attributes(attributes)
    return <<-SQL
      INSERT INTO purchases
      (#{attributes.keys.join(',')})
      VALUES (#{attributes.values.map{|v| Purchase.connection.quote v}.join(', ')})
    SQL
  end
end
