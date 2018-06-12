class VanityController < ApplicationController
  before_action :must_be_admin

  include Vanity::Rails::Dashboard

  layout false
end
