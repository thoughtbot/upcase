require 'spec_helper'

describe Admin::RegistrationsController, "update" do
  it 'save the changes and redirects to the edit section page on success' do
    registration = create(:unpaid_registration)
    section = registration.section

    put :update, section_id: section.to_param, id: registration.to_param,
      registration: { paid: true }

    response.should redirect_to(edit_admin_section_url(section))
    registration.reload.should be_paid
  end
end
