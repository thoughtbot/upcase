require 'spec_helper'

describe SurveyMailer do
  describe '.workshop_survey' do
    it 'is sent to the given email' do
      expect(workshop_survey_email.to).to eq(%w(email@example.com))
    end

    it 'is sent from learn' do
      expect(workshop_survey_email.from).to eq(%w(learn@thoughtbot.com))
    end

    it 'includes a link to the survey' do
      expect(workshop_survey_email).to have_body_text(page_url('feedback'))
    end

    def workshop_survey_email
      section = create(:section)
      SurveyMailer.workshop_survey(section, 'email@example.com')
    end
  end
end
