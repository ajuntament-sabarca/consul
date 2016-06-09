class ApplicationMailer < ActionMailer::Base
  helper :settings
  default from: "web@sabarca.cat"
  layout 'mailer'
end
