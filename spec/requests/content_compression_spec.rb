require 'spec_helper'

feature "A visitor visits the home page" do

  scenario "a visitor has a browser that supports compression" do
    ['deflate','gzip', 'deflate,gzip','gzip,deflate'].each do|compression_method|
      get root_path, {}, {'HTTP_ACCEPT_ENCODING' => compression_method }
      response.headers['Content-Encoding'].should be
    end
  end

  scenario "a visitor's browser does not support compression" do
    get root_path
    response.headers['Content-Encoding'].should_not be
  end

end
