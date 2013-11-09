require 'spec_helper'

feature 'KISSmetrics tracks important events' do
  scenario 'view workshop', js: true do
    section = create(:future_section)

    visit workshop_path(section.workshop)

    expect_kissmetrics_to_receive(
      'Viewed Product',
      'Product Name' => section.workshop.name
    )
  end

  scenario 'view product', js: true do
    product = create(:book_product)

    visit product_path(product)

    expect_kissmetrics_to_receive(
      'Viewed Product',
      'Product Name' => product.name
    )
  end

  scenario 'purchasing a product with paypal', js: true do
    product = create(:book_product)

    visit product_path(product)
    click_link 'For yourself'
    pay_using_paypal

    expect_kissmetrics_to_receive_over_http(
      'Billed',
      'ben@thoughtbot.com',
      'Product Name' => product.name,
      'Amount Billed' => product.individual_price
    )
  end

  scenario 'purchasing a product with stripe', js: true do
    product = create(:book_product)

    visit product_path(product)
    click_link 'For yourself'
    pay_using_stripe

    expect_kissmetrics_to_receive_over_http(
      'Billed',
      'ben@thoughtbot.com',
      'Product Name' => product.name,
      'Amount Billed' => product.individual_price
    )
  end

  scenario 'visitor requests a follow up', js: true do
    workshop = create(:workshop)

    visit workshop_path(workshop)

    click_button 'Submit'

    expect_kissmetrics_to_not_receive 'Requested Followup'

    fill_in 'follow_up_email', with: 'foo@example.com'
    click_button 'Submit'

    expect_kissmetrics_to_receive(
      'Requested Followup',
      'Course Name' => workshop.name
    )
  end

  def expect_kissmetrics_to_receive(event_name, properties)
    kmq = JSON.parse(page.evaluate_script("JSON.stringify(_kmq)"))
    matched_event = kmq.detect { |call| call == ["record", event_name, properties] }
    expect(matched_event).to be
  end

  def expect_kissmetrics_to_not_receive(event_name)
    kmq = JSON.parse(page.evaluate_script("JSON.stringify(_kmq)"))
    matched_event = kmq.detect { |call| call == ["record", event_name] }
    expect(matched_event).to be_nil
  end

  def expect_kissmetrics_to_receive_over_http(event_name, email, properties)
    expect(FakeKissmetrics.events_for(email)).to include(event_name)
    expect(FakeKissmetrics.properties_for(email, event_name)).to include(
      properties
    )
  end
end
