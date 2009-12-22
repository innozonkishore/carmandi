class UserMailer < ActionMailer::Base
  helper :application

  def signup_notification(user)
    setup_email(user)
    @subject    = 'Welcome to carmandi!'
    @body[:url]  = "http://www.carmandi.ca"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{ROOT_DOMAIN}/"
  end

  def reset_notification(user)
    setup_email(user)
    @subject    += "Link to reset your password"
    @body[:url]  = "#{ROOT_DOMAIN}/reset?reset_code=#{user.reset_code}"
  end


  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "support@carmandi.ca"
    @content_type= "text/html"
    @subject     = "[carmandi] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end

