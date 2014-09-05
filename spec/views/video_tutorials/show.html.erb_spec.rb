require "rails_helper"

describe 'video_tutorials/show.html.erb' do
  include Capybara::DSL

  it 'includes video_tutorial FAQs' do
    video_tutorial = create(:video_tutorial)
    create(:question, video_tutorial: video_tutorial, question: 'What color?', answer: 'Blue')
    create(:question, video_tutorial: video_tutorial, question: 'Pets allowed?', answer: 'No')
    assign(:video_tutorial, video_tutorial)
    assign(:offering, video_tutorial)
    assign(:section_teachers, [])
    assign(:sections, [])
    Mocha::Configuration.allow :stubbing_non_existent_method do
      view.stubs(signed_in?: false)
      view.stubs(current_user_has_active_subscription?: false)
      view.stubs(current_user_has_access_to_video_tutorials?: false)
    end

    render template: 'video_tutorials/show', video_tutorial: video_tutorial

    expect(rendered).to include('What color?')
    expect(rendered).to include('Pets allowed?')
    expect(rendered).to include('Blue')
    expect(rendered).to include('No')
  end
end
