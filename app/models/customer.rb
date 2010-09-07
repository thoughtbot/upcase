class Customer
  def self.user_from_customer_id(customer_id)
    open("http://thoughtbot-workshops.chargify.com/customers/#{customer_id}.xml") do |f|
      doc = Nokogiri::XML(f.read)
      user = the_user(doc)
      user.first_name = xml_content(doc, 'first_name')
      user.last_name = xml_content(doc, 'last_name')
      user.email = xml_content(doc, 'email')
      user.organization = xml_content(doc, 'organization')
      user.reference = xml_content(doc, 'reference')
      user
    end
  end

  protected

  def self.xml_content(document, tag_name)
    document.search(tag_name).first.try(:content)
  end

  def self.the_user(doc)
    user = User.find_by_email(xml_content(doc, 'email')) ||
      User.new(:customer_id => xml_content(doc, 'id'),
               :email => xml_content(doc, 'email'),
               :password => 'training01', # because the password is needed
               :password_confirmation => 'training01')
  end
end
