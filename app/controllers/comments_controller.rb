class CommentsController < ApplicationController
  cache_sweeper :comment_sweeper, :only => [:create, :delete]

  def new
    @post = Post.find(params[:post_id])
    if current_user
      @comment = Comment.new(:post => @post, :commenter => current_user)
    else
      @comment = Comment.new(:post => @post, :guest => true)
    end
    render 'new'
  end

  def reply
    @post = Post.find(params[:post_id])
    orig_comment = Comment.find(params[:comment_id])
    if current_user
      @comment = Comment.new(:post => @post, :commenter => current_user, :in_reply_to_seqno => orig_comment.seqno)
    else
      @comment = Comment.new(:post => @post, :guest => true, :in_reply_to_seqno => orig_comment.seqno)
    end
    render 'new'
  end

  def create
    if verify_recaptcha(:model => @comment, :message => 'Oops!  Did you get those verification words right?')
      post = Post.find(params[:post_id])
      comment = post.comments.create(params[:comment])
      CommentMailer.deliver_comment_notice(comment)
      redirect_to show_posts_url(:year => post.created_at.year, :month => post.created_at.month, :day => post.created_at.day, :slug => post.slug)
    else
      @post = Post.find(params[:post_id])
      @comment = Comment.new(params[:comment])
      @comment.post = @post
      render 'new'
    end
  end
end
