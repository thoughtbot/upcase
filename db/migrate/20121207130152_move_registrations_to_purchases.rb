class MoveRegistrationsToPurchases < ActiveRecord::Migration[4.2]
  def up
    insert "insert into purchases (variant, name, email, organization, address1, address2, city, state, zip_code, created_at, updated_at, lookup, coupon_id, paid, payment_method, user_id, paid_price, purchaseable_id, purchaseable_type, comments, billing_email) (select 'individual', first_name || ' ' || last_name, email, organization, address1, address2, registrations.city, registrations.state, registrations.zip_code, registrations.created_at, registrations.updated_at, md5(registrations.id || first_name || last_name), coupon_id, paid, 'freshbooks', user_id, individual_price, section_id, 'Section', comments, billing_email from registrations, sections, courses where registrations.section_id=sections.id and sections.course_id=courses.id)"
    drop_table :registrations
  end

  def down
    create_table "registrations" do |t|
      t.integer "section_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "freshbooks_invoice_id"
      t.string "freshbooks_invoice_url"
      t.integer "coupon_id"
      t.string "email"
      t.string "billing_email"
      t.string "first_name"
      t.string "last_name"
      t.string "organization"
      t.string "phone"
      t.string "address1"
      t.string "address2"
      t.string "city"
      t.string "state"
      t.string "zip_code"
      t.string "freshbooks_client_id"
      t.text "comments"
      t.boolean "paid", default: false, null: false
      t.integer "user_id"
    end

    add_index "registrations", ["paid"], name: "index_registrations_on_paid"
    add_index "registrations", ["section_id"], name: "index_registrations_on_section_id"

    insert "insert into registrations (first_name, last_name, email, organization, address1, address2, city, state, zip_code, created_at, updated_at, coupon_id, paid, user_id, section_id, comments, billing_email) (select substring(name from '.* '), substring(name from ' .*$'), email, organization, address1, address2, city, state, zip_code, created_at, updated_at, coupon_id, paid, user_id, purchaseable_id, comments, billing_email from purchases where purchaseable_type = 'Section')"
  end
end
