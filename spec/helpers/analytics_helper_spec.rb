require "rails_helper"

describe AnalyticsHelper do
  describe "#can_use_analytics?" do
    context "when an ENV['ANALYTICS'] value is present and not masquerading?" do
      it "returns true" do
        ClimateControl.modify ANALYTICS: "anything" do
          allow(helper).to receive(:masquerading?).and_return(false)

          expect(helper.can_use_analytics?).to eq(true)
        end
      end
    end

    context "when we're masquerading" do
      it "returns false" do
        allow(helper).to receive(:masquerading?).and_return(true)

        expect(helper.can_use_analytics?).to eq(false)
      end
    end

    context "when no ENV['ANALYTICS'] value is present" do
      it "returns false" do
        ClimateControl.modify ANALYTICS: nil do
          allow(helper).to receive(:masquerading?).and_return(false)

          expect(helper.can_use_analytics?).to eq(false)
        end
      end
    end
  end
end
