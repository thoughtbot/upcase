require "rails_helper"

RSpec.feature "User can see their trail map progress" do
  background do
    sign_in
  end

  context "new trails" do
    scenario "A user with nothing completed sees they have no progress" do
      trail = create(:trail, :published, topics: [topic])
      create(:step, trail: trail)

      visit practice_path

      expect(page).to have_content("1 step remaining")
    end

    scenario "A user with a completed trails sees their progress" do
      trail = create(
        :trail,
        :published,
        topics: [topic],
        complete_text: "Done!"
      )
      Status.create!(
        user: current_user,
        completeable: trail,
        state: Status::COMPLETE
      )

      visit practice_path

      expect(page).to have_content("Done!")
    end

    scenario "User does not see unpublished trails" do
      unpublished_trail = create(
        :trail,
        name: "This is an unpublished trail",
        published: false
      )
      create(:topic, trails: [unpublished_trail])

      visit practice_path

      expect(page).not_to have_content("This is an unpublished trail")
    end
  end

  private

  def topic
    @topic ||= create(:topic, name: "Workflow")
  end
end
