namespace :dev do
  desc 'Creates sample data for local development'
  task prime: ['db:setup'] do
    unless Rails.env.development?
      raise 'This task can only be run in the development environment'
    end

    require 'factory_girl_rails'

    create_products
    create_bytes
    create_sections_with_workshops
    create_users
  end

  def create_bytes
    header 'Bytes'

    FactoryGirl.create(:byte, title: 'How to slow down your test suite')
    FactoryGirl.create(:byte, title: 'Tips for switching to ed')
  end

  def create_products
    header "Products"

    @prime = FactoryGirl.create(:subscribeable_product, sku: 'prime', name: 'Prime')
    puts_product @prime
    @book = FactoryGirl.create(:book_product, sku: 'VIM', name: 'Vim for Rails Developers')
    puts_product @book

    puts_product FactoryGirl.create(:video_product)
    puts_product FactoryGirl.create(:video_product)
  end

  def create_sections_with_workshops
    header "Sections"

    @in_person_section = FactoryGirl.create(:section,
      workshop: FactoryGirl.create(:in_person_workshop,
        name: 'Intermediate Ruby on Rails',
        short_description: 'Dig deeper into Ruby on Rails.',
        description: 'This intermediate Ruby on Rails workshop is designed for developers who have built a few smaller Rails applications and would like to start making more complicated ones...'
      ),
      address: '41 Winter Street, 8th Floor',
      city: 'Boston',
      state: 'MA',
      zip: '02108',
      starts_on: 2.days.from_now.to_date,
      ends_on:   4.days.from_now.to_date
    )
    puts_section @in_person_section

    @online_section = FactoryGirl.create(:section,
      workshop: FactoryGirl.create(:online_workshop,
        name: 'Intermediate Ruby on Rails',
        short_description: 'Dig deeper into Ruby on Rails.',
        description: 'This intermediate Ruby on Rails workshop is designed for developers who have built a few smaller Rails applications and would like to start making more complicated ones...'
      ),
      starts_on: 2.days.from_now.to_date,
      ends_on:   4.days.from_now.to_date
    )
    puts_section @online_section
  end

  def create_users
    header "Users"

    user = FactoryGirl.create(:admin, email: 'admin@example.com')
    puts_user user, 'admin'

    user = FactoryGirl.create(:user, email: 'none@example.com')
    puts_user user, 'no purchases'

    user = FactoryGirl.create(:user, email: 'product@example.com')
    FactoryGirl.create :purchase, :free, user: user, purchaseable: @book
    puts_user user, 'product purchase'

    user = FactoryGirl.create(:user, email: 'prime@example.com')
    FactoryGirl.create :purchase, :free, user: user, purchaseable: @prime
    puts_user user, 'prime purchase'

    user = FactoryGirl.create(:user, email: 'workshop@example.com')
    FactoryGirl.create :purchase, :free, user: user, purchaseable: @in_person_section
    puts_user user, 'workshop purchase'

    user = FactoryGirl.create(:user, email: 'both@example.com')
    FactoryGirl.create :purchase, :free, user: user, purchaseable: @book
    FactoryGirl.create :purchase, :free, user: user, purchaseable: @in_person_section
    puts_user user, 'product and workshop purchase'

    puts "\n"
  end

  def header(msg)
    puts "\n\n*** #{msg.upcase} *** \n\n"
  end

  def puts_product(product)
    puts "#{product.name}"
  end

  def puts_workshop(workshop)
    puts "#{workshop.name}"
  end

  def puts_section(section)
    puts "#{section.workshop.name} [#{section.online? ? 'Online' : 'In person'}] (#{section.starts_on} - #{section.ends_on})"
  end

  def puts_user(user, description)
    puts "#{user.email} / #{user.password} (#{description})"
  end
end
