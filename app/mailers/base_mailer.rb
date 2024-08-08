class BaseMailer < ActionMailer::Base
  default from: Clearance.configuration.mailer_sender,
    reply_to: Clearance.configuration.mailer_sender

  helper ApplicationHelper
end
