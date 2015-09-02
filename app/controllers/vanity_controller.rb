class VanityController < ApplicationController
  before_filter :must_be_admin

  include Vanity::Rails::Dashboard

  layout false
end
