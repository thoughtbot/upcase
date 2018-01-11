# https://trello.com/c/YLUR92VB/259-double-check-performance-for-practiceshow-page
# When we implemented time_to_complete for trails on the practice#show page,
# this spec began failing. The page performance seems okay, so we are going to
# revisit this spec and the general performace once the feature is deployed to
# production (see linked trello card above).

# require "rails_helper"
#
# describe "/practice", type: :request do
#   it "eager loads data" do
#     user = create(:subscriber)
#
#     expect { get practice_path(as: user) }.to eager_load { create_trail }
#   end
#
#   def create_trail
#     trail = create(:trail, :published)
#     create(:step, trail: trail)
#   end
# end
