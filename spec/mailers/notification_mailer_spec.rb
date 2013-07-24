require 'spec_helper'

describe NotificationMailer do
  describe '.byte_notification' do
    it 'sends a byte notification to the email for the byte' do
      byte = create(
        :byte,
        title: 'Great Article',
        body: 'this is the body'
      )

      email = NotificationMailer.byte_notification(email, byte)

      expect(email.from).to eq(%w(learn@thoughtbot.com))
      expect(email).to have_subject('[Learn] New Byte: Great Article')
      expect(email).to have_body_text(/just published the latest Learn Byte/)
      expect(email).to have_body_text(/Great Article/)
      expect(email).to have_body_text(/this is the body/)
    end

    it 'does not escape the body' do
      byte = create(:byte, title: 'Great Article', body: '> body')

      email = NotificationMailer.byte_notification(email, byte)

      expect(email).not_to have_body_text(/&gt;/)
    end

    it 'links to all bytes' do
      byte = create(:byte, title: 'Great Article', body: 'body')
      email = NotificationMailer.byte_notification(email, byte)
      expect(email).to have_body_text(bytes_url)
    end
  end
end
