class BaseMailer < ActionMailer::Base
  default from: Clearance.configuration.mailer_sender
  add_template_helper PurchasesHelper
  add_template_helper ApplicationHelper
end
