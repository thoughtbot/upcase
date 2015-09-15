ab_test "New landing page" do
  description "Tests a new landing page with video and gifs"
  alternatives :existing, :new
  metrics :signups
end
