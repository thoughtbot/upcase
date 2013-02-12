require 'spec_helper'

describe ProductsController do
  it 'includes the local top articles' do
    relation = stub(top: [])
    Article.stubs(local: relation)

    get :index

    expect(Article).to have_received(:local)
    expect(relation).to have_received(:top)
  end
end
