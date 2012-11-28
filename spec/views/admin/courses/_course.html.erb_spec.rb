require 'spec_helper'

describe 'admin/courses/_course.html.erb' do
  it 'renders sections by starts_on' do
    course = build_stubbed(:course)
    sections = stub('sections', by_starts_on_desc: [])
    course.stubs(sections: sections)

    render 'admin/courses/course', course: course

    sections.should have_received(:by_starts_on_desc).once
  end
end
