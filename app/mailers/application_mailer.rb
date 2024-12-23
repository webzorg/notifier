class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@notifier.com"
  layout "mailer"
end
