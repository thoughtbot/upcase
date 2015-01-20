require "rails_helper"

describe "watchables/_aside.html" do
  context "with repositories" do
    it "renders a link to each repository" do
      repositories = [build_stubbed(:repository), build_stubbed(:repository)]
      watchable = build_stubbed(:video_tutorial, repositories: repositories)

      render_watchable watchable

      expect(rendered).to have_repositories_header

      repositories.each do |repository|
        expect(rendered).to have_css("a[href='#{repository_path(repository)}']")
      end
    end
  end

  context "without repositories" do
    it "skips the repositories header" do
      watchable = build_stubbed(:video_tutorial, repositories: [])

      render_watchable watchable

      expect(rendered).not_to have_repositories_header
    end
  end

  def render_watchable(watchable)
    view_stubs(:current_user_has_active_subscription?).returns(true)
    watchable.repositories.stubs(:ordered).returns(watchable.repositories)
    render "watchables/aside", watchable: watchable
  end

  def have_repositories_header
    have_text("Repositories")
  end
end
