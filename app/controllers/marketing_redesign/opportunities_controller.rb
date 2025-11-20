module MarketingRedesign
  class OpportunitiesController < BaseController
    HUB_CONVERSION_POINT = "Upcase: Contact Us".freeze
    HUB_PROJECT_TYPE = "Team Training / Mentoring".freeze

    def new
    end

    def create
      Hub::Opportunities.create({
        **opportunity_params,
        conversion_point: HUB_CONVERSION_POINT,
        project_type: HUB_PROJECT_TYPE
      })
      redirect_back(
        fallback_location: {action: :new}
      )
    end

    private

    def opportunity_params
      params.require(:opportunity).permit(
        :contact_first_name,
        :contact_last_name,
        :email,
        :company_name,
        :contact_job_title
      )
        .then { combine_contact_name_params(_1) }
    end

    # @param params [ActionController::Parameters]
    # @return [ActionController::Parameters]
    def combine_contact_name_params(params)
      params = params.dup
      contact_name = [
        params.delete(:contact_first_name),
        params.delete(:contact_last_name)
      ].compact_blank.join(" ")
      params[:contact_name] = contact_name if contact_name.present?
      params
    end
  end
end
