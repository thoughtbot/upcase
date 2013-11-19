require 'spec_helper'

describe SectionsController do
  context 'show' do
    it 'redirects to the workshop associated with the section' do
      workshop = create(:workshop, name: 'Learn to fly')
      section = create(:section, workshop: workshop)

      get :show, id: section

      expect(response).to redirect_to workshop_path(workshop)
    end
  end
end
