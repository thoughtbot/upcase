require "rails_helper"

describe 'video_tutorials/show.html.erb' do
  include Capybara::DSL

  it 'includes video_tutorial FAQs' do
    video_tutorial = create(
      :video_tutorial,
      questions: "### What color?\n\nBlue\n\n### Pets allowed?\n\nNo"
    )
    assign(:video_tutorial, video_tutorial)
    assign(:offering, video_tutorial)
    assign(:section_teachers, [])
    assign(:sections, [])
    view_stub_with_return(signed_in?: false)
    view_stub_with_return(current_user_has_active_subscription?: false)
    view_stub_with_return(current_user_has_access_to?: false)

    render template: 'video_tutorials/show', video_tutorial: video_tutorial

    expect(rendered).to include('What color?')
    expect(rendered).to include('Pets allowed?')
    expect(rendered).to include('Blue')
    expect(rendered).to include('No')
  end
end
