require "rails_helper"

describe MarketingRedesign::OpportunitiesController do
  around do |example|
    ClimateControl.modify(ENABLE_MARKETING_REDESIGN: "true") do
      Rails.application.reload_routes!
      example.run
    end
  ensure
    Rails.application.reload_routes!
  end

  describe "#create" do
    it "calls the Hub API opportunities creation endpoint with the correct parameters" do
      allow(Hub::Opportunities).to receive(:create)

      post(
        :create,
        params: {
          opportunity: {
            contact_first_name: "Firstname",
            contact_last_name: "Lastname",
            email: "example@example.com",
            company_name: "Example Company",
            contact_job_title: "Example Job Title"
          }
        }
      )

      expect(Hub::Opportunities).to(
        have_received(:create).with({
          "contact_name" => "Firstname Lastname",
          "email" => "example@example.com",
          "company_name" => "Example Company",
          "contact_job_title" => "Example Job Title",
          :inbound => true,
          :conversion_point => be_present,
          :project_type => be_present
        })
      )
    end
  end
end
