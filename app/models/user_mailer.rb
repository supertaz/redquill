class UserMailer < ActionMailer::Base
  def welcome(user)
    setup_email(user)
    @subject    += 'Welcome to DevKoans!'
    @body[:url]  = "http://www.devkoans.com/"
  end

  def user_contact(target_user, sending_user, email_subject, message_text)
    recipients      "#{target_user.email}"
    from            "donotreply@devkoans.com"
    subject         "[DevKoans] Message from a site user"
    reply_to        "#{sending_user.email}"
    body(            {:target_user => target_user,
                      :email_subject => email_subject,
                      :message => message_text,
                      :sender_name => "#{sending_user.firstname} #{sending_user.lastname}",
                      :sender_email => sending_user.email})
  end

  def non_user_contact(target_user, sender_name, sender_email, email_subject, message_text)
    recipients      "#{target_user.email}"
    from            "donotreply@devkoans.com"
    subject         "[DevKoans] Message from a site visitor"
    reply_to        "#{sender_email}"
    body(           {:target_user => target_user,
                     :email_subject => email_subject,
                     :message => message_text,
                     :sender_name => sender_name,
                     :sender_email => sender_email})
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "accounts@devkoans.com"
      @subject     = "[DevKoans] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
