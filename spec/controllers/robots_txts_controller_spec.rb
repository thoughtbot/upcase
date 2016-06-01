require "rails_helper"

describe RobotsTxtsController do
  describe "#show" do
    context "when environment is production" do
      it "allows all crawlers" do
        stub_rails_environment("production")

        get :show

        expect(response).to render_template "default"
      end
    end

    context "when environment is staging" do
      it "disallows all crawlers" do
        stub_rails_environment("staging")

        get :show

        expect(response).to render_template "disallow_all"
      end
    end
  end
end
