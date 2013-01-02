require 'spec_helper'

describe DesignForDevelopersResourcesController do
  describe 'index' do
    it 'renders the index template for index' do
      get :index
      response.should render_template("index")
      response.should render_template("layouts/d4d_resources")
    end
  end

  describe 'show' do
    it 'renders the requested template for the item' do
      get :show, id: 'color'
      response.should render_template("color")
      response.should render_template("layouts/d4d_resources")
    end

    it 'raises RecordNotFound when there is no matching template' do
      expect do
        get :show, id: 'invalidtemplate'
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
