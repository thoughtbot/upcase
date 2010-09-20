require 'sinatra'

class Courses
  def self.add!(params)
    @courses ||= []
    @courses << params
  end

  def self.find_by_id(id)
    @courses.detect{|course| course['chargify id'] == id}
  end
end

class Misc
  def self.rails_app=(r_app)
    @rails_app = r_app
  end

  def self.rails_app
    @rails_app
  end
end

class Sections
  def self.add!(params)
    @sections ||= []
    @sections << params
  end

  def self.find_by_id(id)
    @sections.detect{|section| section['chargify id'] == id}
  end
end

class Customers
  def self.add!(params)
    @customers ||= []
    @customers << params
  end

  def self.find_by_id(id)
    @customers.detect{|customer| customer[:id] == id}
  end
end

class Subscriptions
  def self.add!(params)
    @subscriptions ||= []
    @subscriptions << params
  end

  def self.find_by_id(id)
    @subscriptions.detect{|subscription| subscription[:id] == id}
  end
end

get '/h/:id/subscriptions/new' do |id|
  <<-HTML
  <form action="http://thoughtbot-workshops.chargify.com/h/#{id}/subscriptions" method="post">
    <input type="text" name="first_name" id="first-name" />
    <input type="text" name="last_name" id="last-name" />
    <input type="text" name="email" id="email" />
    <input type="submit" id="chargify-submit" value="Chargify Submit" />
  </form>
  HTML
end

post '/h/:id/subscriptions' do |id|
  course_id = id_to_course_id(id)
  section_id = id_to_section_id(id)
  create_customer!(params.merge(:id => id))
  create_subscription!(id)
  Capybara.app = Misc.rails_app if Misc.rails_app
  begin
    Capybara.current_session.visit "http://www.example.com/sections/#{section_id}/registrations?customer_id=#{id}&subscription_id=#{id}"
  rescue => e
    p e
    raise e
  end
end

get '/subscriptions/:id.xml' do |id|
  subscription = id_to_subscription(id)

  <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <subscription>
      <id type="integer">#{subscription[:id]}</id>
      <state>#{subscription[:state]}</state>
    </subscription>
  XML
end

get '/customers/:id.xml' do |id|
  customer = id_to_customer(id)

  <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <customer>
      <id type="integer">#{customer[:id]}</id>
      <first_name>#{customer[:first_name]}</first_name>
      <last_name>#{customer[:last_name]}</last_name>
      <email>#{customer[:email]}</email>
      <created_at type="datetime">#{Time.now}</created_at>
      <updated_at type="datetime">#{Time.now}</updated_at>
    </customer>
  XML
end

get '/products/:id.xml' do |id|
  course = Section.find_by_chargify_id(id).course

  <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <product>
      <name>Basic</name>
      <handle>basic</handle>
      <accounting_code>`your value`</accounting_code>
      <description>`your value`</description>
      <interval type="integer">1</interval>
      <interval_unit>month</interval_unit>
      <price_in_cents type="integer">`your value`</price_in_cents>
      <initial_charge_in_cents type="integer">#{course.price.to_i * 1000}</initial_charge_in_cents>
      <product_family>
        <accounting_code>`your value`</accounting_code>
        <description >`your value`</description>
        <handle>`your value`</handle>
        <name>`your value`</name>
      </product_family>
    </product>
  XML
end

helpers do
  def id_to_course_id(id)
    Courses.find_by_id(id)['chargify id']
  end

  def id_to_section_id(id)
    Sections.find_by_id(id)['chargify id']
  end

  def id_to_customer(id)
    Customers.find_by_id(id)
  end

  def id_to_subscription(id)
    Subscriptions.find_by_id(id)
  end

  def id_to_section(id)
    Sections.find_by_id(id)
  end

  def id_to_course(id)
    Courses.find_by_id(id)
  end

  def create_customer!(params)
    Customers.add!(params)
  end

  def create_subscription!(id)
    Subscriptions.add!(:id => id, :state => 'active')
  end
end

ShamRack.at('thoughtbot-workshops.chargify.com').rackup do
  run Sinatra::Application
end

ShamRack.at('thoughtbot-workshops.chargify.com', 443).rackup do
  run Sinatra::Application
end
