require 'spec_helper'

describe 'workshops/show.html.erb', :type => :view do
  include Capybara::DSL

  it 'includes workshop FAQs' do
    workshop = create(:workshop)
    create(:question, workshop: workshop, question: 'What color?', answer: 'Blue')
    create(:question, workshop: workshop, question: 'Pets allowed?', answer: 'No')
    assign(:workshop, workshop)
    assign(:offering, workshop)
    assign(:section_teachers, [])
    assign(:sections, [])
    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(signed_in?: false)
      view.stubs(current_user_has_active_subscription?: false)
      view.stubs(current_user_has_access_to_workshops?: false)
    end

    render template: 'workshops/show', workshop: workshop

    expect(rendered).to include('What color?')
    expect(rendered).to include('Pets allowed?')
    expect(rendered).to include('Blue')
    expect(rendered).to include('No')
  end
end
