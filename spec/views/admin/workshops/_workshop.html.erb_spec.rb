require 'spec_helper'

describe 'admin/workshops/_workshop.html.erb' do
  it 'renders sections by starts_on' do
    workshop = build_stubbed(:workshop)
    sections = stub('sections', by_starts_on_desc: [])
    workshop.stubs(sections: sections)

    render 'admin/workshops/workshop', workshop: workshop

    sections.should have_received(:by_starts_on_desc).once
  end
end
