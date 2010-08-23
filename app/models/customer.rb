class Customer
  def self.user_from_customer_id(customer_id)
    open("http://thoughtbot-workshops.chargify.com/customers/#{customer_id}.xml") do |f|
      doc = Nokogiri::XML(f.read)
      User.new(:customer_id => xml_content(doc, 'id'),
               :first_name => xml_content(doc, 'first_name'),
               :last_name => xml_content(doc, 'last_name'),
               :email => xml_content(doc, 'email'),
               :organization => xml_content(doc, 'organization'),
               :reference => xml_content(doc, 'reference'),
               :password => 'training01', # because the password is needed
               :password_confirmation => 'training01')
    end
  end

  protected

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try(:content)
  end
end
