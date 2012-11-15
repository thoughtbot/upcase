require 'spec_helper'

describe EpisodesController do
  render_views

  describe '#index as xml' do
    it 'should render the index template for published episodes' do
      Episode.stubs(:published).returns([create(:episode)])
      get :index, format: :xml
      Episode.should have_received(:published)
      response.should render_template("index")
    end
  end
end
