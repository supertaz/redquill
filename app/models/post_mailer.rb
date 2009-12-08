class PostMailer < ActionMailer::Base
  def share_post(post, firstname, lastname, email, recipient_name, recipient_email, note)
    recipients    Sanitize.clean(recipient_email)
    from          'donotreply@devkoans.com'
    reply_to      user.email
    subject       "[DevKoans] #{user.firstname} #{user.lastname} has shared a post with you"
    sent_on       Time.now
    body(         {:firstname => firstname, :lastname => lastname, :post => post, :recipient_name => recipient_name, :note => note, :siteurl => 'http://www.devkoans.com/'})
    headers       'return-path' => email
  end
end
