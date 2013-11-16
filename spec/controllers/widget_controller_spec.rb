require 'spec_helper'

describe WidgetController do
  it 'enforces an api key' do
    get :show, key: 'test'

    expect(response).to be_not_found
  end
end
