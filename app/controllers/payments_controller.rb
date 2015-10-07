class PaymentsController < ApplicationController
  def new
    @github_user = Octokit.user(current_user.github_username)
  end
end
