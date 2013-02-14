require 'spec_helper'

describe ProductsController do
  it 'includes the local top articles' do
    published = stub(published: [])
    top = stub(top: published)
    Article.stubs(local: top)

    get :index

    expect(Article).to have_received(:local)
    expect(top).to have_received(:top)
    expect(published).to have_received(:published)
  end
end
