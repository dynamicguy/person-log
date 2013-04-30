class UserMailer < ActionMailer::Base
  default :from => "notifications@personlog.com"
  
  def welcome_email(user)
    mail(:to => user.email, :subject => "Invitation Request Received")
  end
end