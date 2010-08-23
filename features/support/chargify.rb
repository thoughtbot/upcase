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

get '/h/:id/subscriptions/new' do |id|
  <<-HTML
  <form action="http://thoughtbot-workshops.chargify.com/h/#{id}/subscriptions" method="post">
    <input type="text" name="first_name" id="first-name" />
    <input type="text" name="last_name" id="last-name" />
    <input type="text" name="email" id="email" />
    <input type="submit" id="chargify-submit" />
  </form>
  HTML
end

post '/h/:id/subscriptions' do |id|
  course_id = id_to_course_id(id)
  section_id = id_to_section_id(id)
  create_customer!(params.merge(:id => id))

  Capybara.app = Misc.rails_app if Misc.rails_app
  begin
    Capybara.current_session.visit "http://www.example.com/sections/#{section_id}/registrations?customer_id=#{id}"
  rescue => e
    p e
    raise e
  end
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

  def create_customer!(params)
    Customers.add!(params)
  end
end

ShamRack.at('thoughtbot-workshops.chargify.com').rackup do
  run Sinatra::Application
end
