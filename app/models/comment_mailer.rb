class CommentMailer < ActionMailer::Base
  def comment_notice(comment, firstname, email)
    recipients    email
    from          'donotreply@devkoans.com'
    subject       "[DevKoans] Someone commented on your post"
    sent_on       Time.now
    body(         {:firstname => firstname, :comment => comment, :siteurl => 'http://www.devkoans.com/'})
  end
end
