class CommentMailer < ActionMailer::Base
  def comment_notice(comment)
    recipients    comment.post.poster.email
    from          'donotreply@devkoans.com'
    subject       "[DevKoans] Someone commented on your post"
    sent_on       Time.now
    body(         {:comment => comment,
                   :siteurl => 'http://www.devkoans.com/'})
  end
end
