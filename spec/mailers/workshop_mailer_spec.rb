require 'spec_helper'

describe WorkshopMailer do
  describe '.follow_up' do
    include Rails.application.routes.url_helpers

    it "mentions the workshop name" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).body).to include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      expect(follow_up_for.from).to eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")

      expect(follow_up_for(workshop: workshop).subject).to include "Foo bar"
    end

    it "is sent to the follow up email" do
      follow_up = create(:follow_up)

      expect(follow_up_for(follow_up: follow_up).to).to eq([follow_up.email])
    end

    it "links to the workshop" do
      workshop = create(:workshop)

      expect(follow_up_for(workshop: workshop).body).to include workshop_url(workshop)
    end

    def follow_up_for(options = {})
      options[:follow_up] ||= create(:follow_up)
      options[:workshop] ||= create(:workshop)
      section = create(:section, workshop: options[:workshop])

      WorkshopMailer.follow_up options[:follow_up], section
    end
  end

  describe '.section_reminder' do
    it 'has the correct subject' do
      expect(sent_email.subject).to match(/#{workshop_name}/)
    end

    it 'has the correct recipient' do
      expect(sent_email.to).to include(recipient)
    end

    it "has the registrant's name in the body" do
      expect(sent_email.body).to include('Benny Burns')
    end

    context 'for an online workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:online_section_purchase, comments: 'comments and requests')
        section = purchase.purchaseable
        email = WorkshopMailer.section_reminder(purchase.id, section.id)

        expect(email).not_to have_body_text(/following comments|dietary restrictions/)
      end
    end

    context 'for an in-person workshop' do
      it 'does not contain a section about comments or dietary restrictions' do
        purchase = create(:in_person_section_purchase, comments: 'comments and requests')
        section = purchase.purchaseable
        email = WorkshopMailer.section_reminder(purchase.id, section.id)

        expect(email).to have_body_text(/following comments|dietary restrictions/)
      end
    end

    def workshop_name
      'Hilarious Backbone.js'
    end

    def recipient
      'frankie-z@example.com'
    end

    def sent_email
      workshop = create(:workshop, name: workshop_name)
      section = create(:section, workshop: workshop)

      purchase = create(:purchase,
                        purchaseable: section,
                        email: recipient,
                        name: 'Benny Burns')

      WorkshopMailer.section_reminder(purchase, section)
    end
  end

  describe '.teacher_notification' do
    it "mentions the workshop name in the body" do
      workshop = create(:workshop, name: "Foo bar")

      expect(teacher_notification(workshop: workshop).body).to include "Foo bar"
    end

    it "is from learn@thoughtbot.com" do
      expect(teacher_notification.from).to eq(%w(learn@thoughtbot.com))
    end

    it "mentions the workshop name in the subject" do
      workshop = create(:workshop, name: "Foo bar")

      expect(teacher_notification(workshop: workshop).subject).to include "Foo bar"
    end

    it "is sent to the teacher" do
      teacher = create(:teacher)
      expect(teacher_notification(teacher: teacher).to).to eq([teacher.email])
    end

    def teacher_notification(options = {})
      options[:teacher] ||= create(:teacher)
      options[:workshop] ||= create(:workshop)

      WorkshopMailer.teacher_notification(options[:teacher], create(:section, workshop: options[:workshop]))
    end
  end

  describe '.section_notification' do
    it 'sends a video notification to the email for the video' do
      workshop = create(:workshop, name: 'Workshop name')
      video = create(:video, title: 'Title', position: 2, watchable: workshop)

      email = WorkshopMailer.video_notification(email, video)

      expect(email.from).to eq(%w(learn@thoughtbot.com))
      expect(email).to have_subject('[Learn] Workshop name: Title')
      expect(email).to have_body_text(/Workshop name video lesson 2, Title/)
    end
  end

  describe '.office_hours_reminder' do
    it 'sends an office_hour notification to the email for the section' do
      workshop = create(:workshop, name: 'Workshop name', office_hours: '1pm')
      section = create(:section, workshop: workshop)

      email = WorkshopMailer.office_hours_reminder(section, email)

      expect(email.from).to eq(%w(learn@thoughtbot.com))
      expect(email).to have_subject('[Learn] Workshop name: Office Hours')
      expect(email).to have_body_text(/This is a reminder that the Workshop name office hours are today at 1pm/)
    end
  end

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
      WorkshopMailer.workshop_survey(section, 'email@example.com')
    end
  end
end
