require 'spec_helper'

feature "A visitor visits the home page" do

  scenario "a visitor has a browser that supports compression" do
    ['deflate','gzip', 'deflate,gzip','gzip,deflate'].each do|compression_method|
      get root_path, {}, {'HTTP_ACCEPT_ENCODING' => compression_method }
      expect(response.headers['Content-Encoding']).to be
    end
  end

  scenario "a visitor's browser does not support compression" do
    get root_path
    expect(response.headers['Content-Encoding']).not_to be
  end

end
